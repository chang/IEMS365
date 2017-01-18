create_xgb_matrices <- function(data, type){
  # create sparse matrices for training from model matrices
  # type = 'train' for training data
  # type = 'test for testing data
  
  if (type == 'train'){
    train_xgb_sparse <- sparse.model.matrix(status_group ~ .-1, 
                                            data = select(data, -id))
    
    train_xgbmatrix <- xgb.DMatrix(data=train_xgb_sparse, 
                                   label=as.integer(data$status_group)-1)
                                     
    
    return(train_xgbmatrix)
  } else if (type == "test"){
    test_xgb_sparse <- sparse.model.matrix(status_group ~ .-1,
                                           data = bind_cols(data.frame(status_group=1:nrow(data)),
                                                            select(data, -id)))
    return(test_xgb_sparse)
  } 
  
}

eval_xgb_cv <- function(model_cv){
  # Evaluate cross validated results by:
  # plotting train and test iterations vs. gain curves
  # highlighting location of minimum test error
  
  index_min_error <- 
    which(model_cv$test.merror.mean == min(model_cv$test.merror.mean))
  
  cvplot <- ggplot(data = data.frame(x = 1:nrow(model_cv), 
                                     train = model_cv$train.merror.mean, 
                                     test = model_cv$test.merror.mean)) +
                   geom_line(aes(x = x, y = train)) +
                   geom_line(aes(x = x, y = test))
  plot(cvplot)
  message("Minimum test error")
  message(paste(index_min_error, "iterations\n", model_cv$test.merror.mean[index_min_error]))
}