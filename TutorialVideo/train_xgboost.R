require(dplyr)
require(xgboost)
require(magrittr)
require(Matrix)

source('./Preprocessing/load.R')
source('./feature_engineering.R')

### Test old configuration------------------------------------------

old_config <- function(data){
  data <- select(data, gps_height, date_recorded,
                  amount_tsh, longitude, latitude,
                  basin, region, 
                  population, public_meeting, 
                  scheme_management, permit, construction_year,
                  extraction_type_class,
                  management_group, payment_type,
                  water_quality, quantity_group,
                  source, waterpoint_type)
  return(data)
  
}
train <- bind_cols(select(train, id, status_group), old_config(train))
test <- bind_cols(select(test, id), old_config(test))

#####################################################################

# Relevel training labels to use multi:softmax on xgboost
levels(train$status_group) <- c(0, 1, 2)

# Create xgboost matrices
train_xgbmatrix <- create_xgb_matrices(train, type = 'train')
test_xgbmatrix <- create_xgb_matrices(test, type = 'test')




### Model CV
params <- c(
  
)

# 258 .1889
model_cv <- 
xgb.cv(data = train_xgbmatrix,
       nrounds = 1000, nthread = 7,
       nfold = 3,
       objective = "multi:softmax",
       eta = .1,
       max.depth = 12,
       min_child_weight = 6,
       colsample_bytree = .4,
       subsample = 1,
       gamma = 0,
       eval_metric = "merror",
       num_class = 3,
       print.every.n = 2)
eval_xgb_cv(model_cv)

### Model Training .1903
model_xgb <- 
xgb.train(data = train_xgbmatrix,
          nrounds = 1000, nthread = 7,
          objective = "multi:softmax",
          eta = .1,
          max.depth = 12,
          min_child_weight = 6,
          colsample_bytree = .4,
          subsample = 1,
          gamma = 0,
          eval_metric = "merror",
          num_class = 3)

### Model prediction, submission generate
submission <- data.frame(id = test$id, label = predict(model_xgb, test_xgb_sparse))
submission$label <- as.factor(submission$label)
levels(submission$label) <- c("functional", "functional needs repair", "non functional")
names(submission) <- c('id', 'status_group')

write.csv(submission, file = "submission2.csv", row.names = F)











