#' @title Partition a data frame in a training set and testing set and eventually a inValidation set
#' 
#' @description
#' This function uses the createDataPartition function from the caret package to create partitions of the data. 
#' By default, it splits the data into the following proportions: 75% training, 25% testing.
#' A validation set can be included by specifying the use.validation parameter. In this case, the data will be split into the following proportions: 45% training, 30% validation, 25% testing.
#' 
#' @param data Data frame to partition
#' @param column.partition Column name existing in the data frame that will be used for the split
#' @param use.validation Define if a validation set is needed.(Default value is FALSE)
#' @return create global variables names as follow : training,testing and validation (if use.validation = T)
require(caret)
partitionData <- function(data, column.partition, use.validation=F)
{
  # Split data: 75% training, 25% testing.
  inTrain <- createDataPartition(data[[column.partition]],
                                 p=.75,
                                 list=FALSE)
  training <<- data[inTrain,]
  testing <<- data[-inTrain,]
  
  # If using validation set, split data: 45% training, 30% validation, 25% testing.
  if(use.validation) {
    inValidation <<- createDataPartition(training[[column.partition]],
                                         p=.4,
                                         list=FALSE)   
    validation <<- training[inValidation,]
    training <<- training[-inValidation,]
  }  
}
