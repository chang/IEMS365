require(Matrix)
require(ggplot2)

create_xgb_matrices <- function(data, type){
  # create sparse matrices for training from model matrices
  # type = 'train' for training data
  # type = 'test for testing data
  
  if (type == 'train'){
    train_xgb_sparse <- sparse.model.matrix(functional_status ~ .-1, 
                                            data = select(data, -id))
    
    train_xgbmatrix <- xgb.DMatrix(data=train_xgb_sparse, 
                                   label=as.integer(data$functional_status)-1)
                                     
    return(train_xgbmatrix)
  } else if (type == "test"){
    test_xgb_sparse <- sparse.model.matrix(functional_status ~ .-1,
                                           data = bind_cols(data.frame(functional_status=1:nrow(data)),
                                                            select(data, -id)))
    return(test_xgb_sparse)
  } 
  
}

eval_xgb_cv <- function(model_cv){
  # Evaluate cross validated results by:
  # plotting train and test iterations vs. gain curves
  # highlighting location of minimum test error
  error <- model_cv$evaluation_log
  
  index_min_error <- 
    which(error$test_error_mean == min(error$test_error_mean))
  
  cvplot <- ggplot(data = data.frame(x = 1:nrow(error), 
                                     train = error$train_error_mean, 
                                     test = error$test_error_mean)) +
                   geom_line(aes(x = x, y = train), color='firebrick') +
                   geom_line(aes(x = x, y = test), color='skyblue') +
                   xlab("n iterations")
  plot(cvplot)
  message("Minimum test error: ", min(error$test_error_mean))
  message("Classification rate: ", 1-min(error$test_error_mean))
}