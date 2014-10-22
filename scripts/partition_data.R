#' @title Partition a data frame in a training set and testing set and eventually a in.Validation set
#' 
#' @description
#' This function uses the createDataPartition function from the caret package to create partitions of the data. 
#' By default, it splits the data into the following proportions: 75% training, 25% testing.
#' A validation set can be included by specifying the use.validation parameter. In this case, the data will be split into the following proportions: 45% training, 30% validation, 25% testing.
#' 
#' @param data Data frame to partition
#' @param outcome.name Column name existing in the data frame that will be used for the split
#' @param use.validation Define if a validation set is needed.(Default value is FALSE)
#' @return create global variables names as follow : train.set,test.set and validation (if use.validation = T)
require(caret)
partition.data = function(data, outcome.names, primary.outcome, use.validation=F)
{
   message("Partitioning data for feature selection analysis...")
   
   # Split data: 75% training, 25% testing.
   in.train = createDataPartition(data[[primary.outcome]], 
                                 p=.75,
                                 list=FALSE)
   train.set = data[in.train,]
   test.set = data[-in.train,]
  
   # If using validation set, split data: 45% training, 30% validation, 25% testing.
   if(use.validation) {
      in.Validation = createDataPartition(train.set[[primary.outcome]],
                                         p=.4,
                                         list=FALSE)   
      validation.set = train.set[in.Validation,]
      train.set = train.set[-in.Validation,]
    
      # Break out data from outcomes in validation set.
      validation.outcomes <<- validation.set[, outcome.names]
      validation.data <<- not.named(outcome.names, validation.set)
  }  
  
  # Break out data from outcomes in training and test sets.
  train.outcomes <<- train.set[, outcome.names]
  train.data <<- not.named(outcome.names, train.set)
  test.outcomes <<- test.set[, outcome.names]
  test.data <<- not.named(outcome.names, test.set)
}
