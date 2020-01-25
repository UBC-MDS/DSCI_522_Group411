# author: Katie Birchard
# date: 2020-01-24

"""This script conducts a random forest regression analysis and outputs 
a table of the most important features. This script takes a path to an 
input file and a path to an output directory as arguments.

Usage: regression.py <file_path_train> <output>

Arguments:
<file_path_train>   Path (including filename) to the cleaned feather training dataset.
<output>            Path (excluding filename) to the figures/tables output directory
"""

# Import all necessary packages
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.model_selection import RandomizedSearchCV, cross_val_score
import altair as alt
from pyarrow import feather
from docopt import docopt

opt = docopt(__doc__)

# Define main function
def main(file_path_train, output):
  # read in the data
  print("Starting to load in data...")
  train_data = pd.read_feather(file_path_train)
  train_x, train_y = feature_target_split(train_data)
  feature_df = random_forest_regression(train_x, train_y, output, train_data)
  plot_feature_importance(feature_df, output)
  print("Finished loading data...")
  
  # add function to write to output directory

# Define function to split data into feature and targets
def feature_target_split(train_data):
  """
  """
  print("Preprocessing data...")
  train_x = train_data[['region', 'type', 'month']]
  train_y = train_data['average_price']
  categorical_features = ['region', 'type', 'month']
  preprocessor = ColumnTransformer(transformers=[
    ('ohe', OneHotEncoder(), categorical_features)
    ])
  train_x = preprocessor.fit_transform(train_x)
  return train_x, train_y
  print("Finished preprocessing data...")
  
# Define function to carry out random forest regression 
def random_forest_regression(train_x, train_y, output, train_data):
  """
  """
  print("Starting random forest regression...")
  rfr = RandomForestRegressor()
  rfr.fit(train_x, train_y)
  rfr_parameters = {'max_depth': range(1, 20),
                  'n_estimators': range(1, 100)}
  random_rfr = RandomizedSearchCV(rfr, rfr_parameters, cv=5, scoring='neg_mean_squared_error')
  random_rfr.fit(train_x, train_y)
  fold_accuracies = cross_val_score(estimator=random_rfr, X=train_x, y=train_y, cv=5)
  cv_scores = pd.DataFrame({'Fold': [1, 2, 3, 4, 5],
                    'Neg Mean Squared Error': fold_accuracies})
  cv_scores.to_csv(output + "cv_scores.csv")
  features = pd.get_dummies(train_data[['region', 'type', 'month']])
  feature_list = list(features.columns)
  feature_df = pd.DataFrame({"feature_names": feature_list,
             "importance": random_rfr.best_estimator_.feature_importances_})
  feature_df = feature_df.sort_values(["importance"], ascending=False)
  # print(feature_df)
  feature_df.to_csv(output + "feature_importance.csv")
  return feature_df
  print("Finished random forest regression...")

# Define plot function  
def plot_feature_importance(feature_df):
  """
  """
  print("Starting to plot most important features...")
  feature_plot = alt.Chart(feature_df[:10]).mark_bar(color="red", opacity=0.6).encode(
    x= alt.X("feature_names:N",
             sort=alt.SortField(field="importance:Q"),
             title="Features"),
    y = alt.Y("importance:Q", title="Feature Importance")
    ).properties(title="10 Most Important Predictors of Avocado Price",
             width=400)
  feature_plot.save(output + "feature_plot.png", webdriver="chrome")
  print("Finished plotting most important features...")

# Call main function
if __name__ == "__main__":
  main(opt["<file_path_train>"], opt["<output>"])
