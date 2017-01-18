require(dplyr)
require(magrittr)

format_data <- function(data){
  # Remove proxy variables, format date, and relevel factors to match
  data <- 
    data %>% select(-region_code, -recorded_by, -extraction_type, -extraction_type_group, -source_type,
                    -quality_group, -quantity, -source_class, -waterpoint_type_group, -payment)
  
  data$date_recorded <- as.Date(as.character(data$date_recorded), format = "%Y-%m-%d")
  
  data$scheme_management[data$scheme_management=="None"] <- "Other"
  data$scheme_management <- droplevels(data$scheme_management)
  
  return(data)
}

# Load training data
train_labels <- read.csv("./data/train_labels.csv")
train_values <- read.csv("./data/train_values.csv")
train <- inner_join(train_labels, train_values, by = 'id')
rm(train_labels, train_values)

# Load testing data
test <- read.csv("./data/test_values.csv")

# Clean data
train <- format_data(train)
test <- format_data(test)

