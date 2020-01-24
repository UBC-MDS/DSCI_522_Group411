# author: Katie Birchard
# date: 2020-01-24

"""This script conducts a random forest regression analysis and outputs 
a table of the most important features. This script takes a path to an 
input file and a path to an output directory as arguments.

Usage: regression.py --file_path=<file_path> --output=<output>

Options:
--file_path=<file_path>   Path (including filename) to a cleaned feather dataset.
--output=<output> Path (including filename) to the figures/tables output 
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
  data = pd.read_feather(file_path)
  # add function to write to output directory

# load in the cleaned feather dataset

# Call main function
if __name__ == "__main__":
  main(opt["--file_path"], opt["--statistic"])
