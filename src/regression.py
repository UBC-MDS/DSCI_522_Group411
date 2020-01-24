# author: Katie Birchard
# date: 2020-01-24

"""This script conducts a random forest regression analysis and outputs 
a table of the most important features. This script takes a path to an 
input file and a path to an output directory as arguments.

Usage: regression.py --file_path_train=<file_path_train> --output=<output>

Options:
--file_path_train=<file_path_train>   Path (including filename) to thecleaned feather 
training dataset.
--output=<output>                     Path (including filename) to the figures/tables output 
by the regression analysis
"""

# Import all necessary packages
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.model_selection import RandomizedSearchCV, cross_val_score
import altair as alt
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from pyarrow import feather

opt = docopt(__doc__)

# Define main function
def main(file_path, output):
  # read in the data
  train_data = pd.read_feather(file_path_train)
  # add function to write to output directory

# Define function to split data into feature and targets
def feature_target_split(data):
  """
  """
  train_x = train_data[['region', 'type', 'month']]
  train_y = train_data['average_price']
  categorical_features = ['region', 'type', 'month']
  preprocessor = ColumnTransformer(transformers=[
    ('ohe', OneHotEncoder(), categorical_features)
    ])
  train_x = preprocessor.fit_transform(train_x)
  
# Define function to carry out random forest regression 
def random_forest_regression(train_x, train_y):
  """
  """
  rfr = RandomForestRegression()
  rfr.fit(train_x, train_y)
  rfr_parameters = {'max_depth': range(1, 20),
                  'n_estimators': range(1, 100)}
  random_rfr = RandomizedSearchCV(rfr, rfr_parameters, cv=5, scoring='neg_mean_squared_error')
  random_rfr.fit(train_x, train_y)
  fold_accuracies = cross_val_score(estimator=random_rfr, X=train_x, y=train_y, cv=5)
  cv_scores = pd.DataFrame({'Fold': [1, 2, 3, 4, 5],
                    'Neg Mean Squared Error': fold_accuracies})
  print(cv_scores)
  features = pd.get_dummies(train_data[['region', 'type', 'month']])
  feature_list = list(feature.columns)
  feature_df = pd.DataFrame({"feature_names": feature_list,
             "importance": random_rfr.best_estimator_.feature_importances_})
  feature_df = feature_df.sort_values(["importance"], ascending=False)
  print(feature_df)
  
def plot_feature_importance(feature_df):
  """
  """
  
    
  

# Call main function
if __name__ == "__main__":
  main(opt["--file_path_train"], opt["--output"])
