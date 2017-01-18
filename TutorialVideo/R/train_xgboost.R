###----------------------------------------------------------------
# This is a demo of how a machine learning model - XGBOOST -
# can be trained to classify the functional status of pumps
# in our Tanzanian water pump example.
###----------------------------------------------------------------

require(dplyr)
require(xgboost)
require(magrittr)
source('./R/model_functions.R')
# setwd("/home/eric/Documents/winter2017/IEMS365/TutorialVideo")

# Read in
train <- read.csv("Data/demo_data_clean.csv")

# Relevel training labels to use binary:logistic on xgboost
levels(train$functional_status) <- c(0, 1)

# Create xgboost matrices
train_xgbmatrix <- create_xgb_matrices(train, type = 'train')

# Train XGBOOST model to classify pump status
model_cv <- 
  xgb.cv(data = train_xgbmatrix,
         objective = "binary:logistic",
         eval_metric = "error",
         nrounds = 1000, 
         nthread = 7,
         nfold = 3,
         eta = .1,
         max.depth = 12,
         min_child_weight = 6,
         colsample_bytree = .4,
         subsample = 1,
         gamma = 0,
         print_every_n = 2)

# Find optimal number of iterations and test error
eval_xgb_cv(model_cv)
