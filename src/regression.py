# author: Katie Birchard
# date: 2020-01-24

"""This script conducts multiple regression analyses and outputs 
a table of the most important features determined  by each one. 
This script takes a path to an input file and a path to an output 
directory as arguments.

Usage: regression.py <file_path_train> <file_path_test> <output>

Arguments:
<file_path_train>   Path (including filename) to the cleaned feather training dataset.
<file_path_test>    Path (including filename) to the cleaned feather test dataset.
<output>            Path (excluding filename) to the figures/tables output directory.
"""

# Import all necessary packages
import pandas as pd
import numpy as np
from joblib import dump, load
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.compose import ColumnTransformer
from sklearn.model_selection import RandomizedSearchCV, cross_val_score
from sklearn.linear_model import Ridge
import altair as alt
from pyarrow import feather
from docopt import docopt
import os.path
from os import path

opt = docopt(__doc__)

# Define main function
def main(file_path_train, file_path_test, output):
  """
  Runs through all functions involved in the regression analysis.
  
  Parameters:
  ----------
  file_path_train: (filepath) file path to the training data
  file_path_test: (filepath) file path to the test data
  output: (filepath) file path to the output
  """
  # Check if the input files are a valid path
  assert path.exists(file_path_train) == True, "Input file path to training data does not exist"
  assert path.exists(file_path_test) == True, "Input file path to test data does not exist"  
  
  # Check if the output file is a valid path
  assert path.exists(output) == True, "Output file path does not exist"
  
  # read in the data
  print("Starting to load in data...")
  train_data = pd.read_feather(file_path_train)
  test_data = pd.read_feather(file_path_test)
  train_x, train_y, test_x, test_y = feature_target_split(train_data, test_data)
  feature_df = random_forest_regression(train_x, train_y, test_x, test_y, output, train_data)
  lr_feature_df = regularized_linear_regression(train_x, train_y, test_x, test_y, output, train_data)
  plot_feature_importance(feature_df, lr_feature_df, output)
  print("Finished")
  
  

# Define function to split data into feature and targets
def feature_target_split(train_data, test_data):
  """
  Splits the data into feature and targets and applies
  one hot encoding.
  
  Parameters:
  ----------
  train_data: (dataframe) training data
  
  Returns:
  --------
  train_x: (array) - train feature set
  train_y: (list) - train target set
  test_x: (array) - test feature set
  test_y: (list) - test target set
  """
  print("Preprocessing data...")
  train_x = train_data[['lat', 'lon', 'type', 'season']]
  train_y = train_data['average_price']
  test_x = test_data[['lat', 'lon', 'type', 'season']]
  test_y = test_data['average_price']
  numeric_features = ['lat', 'lon']
  
  # Check if numeric features are really numeric
  assert type(train_x['lat'][1]) == np.float64, "numeric feature should be type float"
  assert type(train_x['lon'][1]) == np.float64, "numeric feature should be type float"
  assert type(test_x['lat'][1]) == np.float64, "numeric feature should be type float"
  assert type(test_x['lon'][1]) == np.float64, "numeric feature should be type float"
  
  categorical_features = ['type', 'season']
  
  # Check if categorical features are strings
  assert type(train_x['type'][1]) == str, "categorical feature should be type string"
  assert type(train_x['season'][1]) == str, "categorical feature should be type string"
  assert type(test_x['type'][1]) == str, "categorical feature should be type string"
  assert type(test_x['season'][1]) == str, "categorical feature should be type string"
  
  preprocessor = ColumnTransformer(transformers=[
    ('scaler', StandardScaler(), numeric_features),
    ('ohe', OneHotEncoder(), categorical_features)
    ])
  
  # Apply preprocessing to training dataset
  train_x = pd.DataFrame(preprocessor.fit_transform(train_x),
                         index=train_x.index,
                         columns = (numeric_features +
                                   list(preprocessor.named_transformers_['ohe']
                                       .get_feature_names(categorical_features))))
                                       
  # Apply preprocessing to test dataset
  test_x = pd.DataFrame(preprocessor.transform(test_x),
                        index=test_x.index,
                        columns=train_x.columns)                                     
                                       
  # Check to see if one-hot-encoding added extra 4 columns for season and type
  assert len(train_x.columns) == 8, "One-Hot-Encoding failed on the training set..."
  assert len(test_x.columns) == 8, "One-Hot-Encoding failed on the test set..."
  
  # Return the preprocessed training data for regression analysis
  return train_x, train_y, test_x, test_y
  print("Finished preprocessing data...")
  
# Define function to carry out random forest regression 
def random_forest_regression(train_x, train_y, test_x, test_y, output, train_data):
  """
  Carries out the random forest regression analysis and 
  calculates feature importance.
  
  Parameters:
  -----------
  train_x: (array) - train feature set
  train_y: (list) - train target set
  test_x: (array) - test feature set
  test_y: (list) - test target set
  output: (filepath) - filepath to where the results are stored
  train_data: (dataframe) training data
  
  Returns:
  --------
  feature_df: (dataframe) dataframe of feature names and importances
  csv file of cross-validation scores
  csv file of feature importances
  csv file of test score
  """
  print("Performing random forest regression...")
  rfr = RandomForestRegressor(random_state=123)
  rfr_parameters = {'max_depth': range(1, 20),
                  'n_estimators': range(1, 100)}
  random_rfr = RandomizedSearchCV(rfr, rfr_parameters, cv=5, scoring='neg_mean_squared_error')
  random_rfr.fit(train_x, train_y)
  fold_accuracies_rfr = cross_val_score(estimator=random_rfr, X=train_x, y=train_y, cv=5)
  cv_scores = pd.DataFrame({'Fold': [1, 2, 3, 4, 5],
                            'Neg Mean Squared Error': np.around(fold_accuracies_rfr, 2)})
                    
  # Check that the regression worked and all cv_scores are not equal to zero
  assert cv_scores['Neg Mean Squared Error'].any() != 0, "Random Forest Regression failed..."
  
  # Outputting the cv_scores to the results folder as a csv file                  
  # calculate the average error from these scores in final report
  cv_scores.to_csv(output + "cv_scores_rfr.csv", index=False)
  feature_list = list(train_x.columns)
  nice_feature_list = ['Latitude', 'Longitude',
                     'Conventional Type', 'Organic Type',
                     'Fall Season', 'Spring Season',
                     'Summer Season', 'Winter Season']
  feature_df = pd.DataFrame({"feature_names": nice_feature_list,
             "importance": np.around(random_rfr.best_estimator_.feature_importances_, 2)})
  feature_df = feature_df.sort_values(["importance"], ascending=False)
  feature_df.to_csv(output + "feature_importance_rfr.csv", index=False)
  return feature_df
  
  # Now get test accuracy
  rfr_test_score = np.around(random_rfr.score(test_x, test_y), 2)
  rfr_test_score = pd.DataFrame({'test': [rfr_test_score]})
  rfr_test_score.to_csv(output + "lr_test_accuracy.csv", index=False)
  
  assert len(rfr_test_score) != 0, "rfr test score is not being calculated..."
  
# Define function to carry out linear regression
def regularized_linear_regression(train_x, train_y, test_x, test_y, output, train_data):
  """
  Carries out linear regression analysis using L2 regularization
  and calculates weights assigned to each feature.
  
  Parameters:
  -----------
  train_x: (array) - train feature set
  train_y: (list) - train target set
  test_x: (array) - test feature set
  test_y: (list) - test target set
  output: (filepath) - filepath to where the results are stored
  train_data: (dataframe) training data
  
  Returns:
  --------
  lr_feature_df: (dataframe) dataframe of feature names and weights
  csv file of cross-validation scores
  csv file of feature weights
  csv file of test score
  """ 
  print("Performing regularized linear regression...")
  # set the model
  r = Ridge()
  
  # find the best hyperparmater, alpha, using cross validation
  param_grid = {"alpha": [i for i in range(0, 1000, 1)]}
  r_rs = RandomizedSearchCV(r, param_grid, cv=5, random_state=123).fit(train_x, train_y)
  
  # Check to ensure alpha value is plausible (i.e. not zero)
  assert r_rs.best_params_['alpha'] != 0, "Hyperparameter tuning returned bad alpha value"
  
  # Use the best alpha in the model
  r2 = Ridge(alpha=r_rs.best_params_['alpha'])
  r2.fit(train_x, train_y)
  fold_accuracies_lr = cross_val_score(estimator=r2, X=train_x, y=train_y, cv=5)
  cv_scores_lr = pd.DataFrame({'Fold': [1, 2, 3, 4, 5],
                               'Neg Mean Squared Error': np.around(fold_accuracies_lr, 2)})
                               
  # Check that the regression worked and all cv_scores are not equal to zero
  assert cv_scores_lr['Neg Mean Squared Error'].any() != 0, "Regularized linear regression failed..."   

  cv_scores_lr.to_csv(output + "cv_scores_lr.csv", index=False)
  feature_list = list(train_x.columns)
  nice_feature_list = ['Latitude', 'Longitude',
                     'Conventional Type', 'Organic Type',
                     'Fall Season', 'Spring Season',
                     'Summer Season', 'Winter Season']
  lr_feature_df = pd.DataFrame({"feature_names": nice_feature_list,
             "weights": np.around(r2.coef_, 2)})
  lr_feature_df = lr_feature_df.sort_values(["weights"], ascending=False)
  lr_feature_df.to_csv(output + "feature_weights_lr.csv", index=False)
  return lr_feature_df  
  
  # Now score on the test data
  lr_test_score = np.around(r2.score(test_x, test_y), 2)
  lr_test_score = pd.DataFrame({'test': [lr_test_score]})
  lr_test_score.to_csv(output + "lr_test_accuracy.csv", index=False)

  assert len(lr_test_score) != 0, "lr test score is not being calculated..."
  
# Define plot function  
def plot_feature_importance(feature_df, lr_feature_df, output):
  """
  Creates a ranked bar chart of which features are the most important
  predictors of the random forest regression.
  
  Parameters:
  -----------
  feature_df: (dataframe) dataframe of feature names and importances/weights
  output: (filepath) filepath to where the results are stored
  
  Returns:
  --------
  image file of feature importance plots
  """
  print("Plotting most important features from random forest...")
  rfr_plot = alt.Chart(feature_df).mark_bar(color="green", opacity=0.6).encode(
    y= alt.Y("feature_names:N",
             sort=alt.SortField(field="importance:Q"),
             title="Features"),
    x = alt.X("importance:Q", title="Feature Importance")
    ).properties(title="Random Forest Regression",
             width=200)
  
  print("Plotting most important features from linear regression...")
  lr_plot = alt.Chart(lr_feature_df).mark_bar(color="blue", opacity=0.6).encode(
    y = alt.Y("feature_names:N",
               sort=alt.SortField(field="weights:Q"),
               title="Features"),
    x = alt.X("weights:Q", title="Coefficient Weights")
  ).properties(title="Linear Regression",
           width=200)
           
  feature_plot = rfr_plot | lr_plot
             
  # Saving plot as an output           
  feature_plot.save(output + "feature_plot.png", webdriver="chrome")

# Call main function
if __name__ == "__main__":
  main(opt["<file_path_train>"], opt["<file_path_test>"], opt["<output>"])
