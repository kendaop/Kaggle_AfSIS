# Session variables.
setwd("C:/Users/K-Dawg/Documents/Git/Kaggle_AfSIS")
ignorecores = 1
methods = c("lasso", "rf", "gbm", "avNNet")
use.validation = FALSE
TRAIN = FALSE
ANALYZE = FALSE
GRAPH = FALSE
RETRAIN = FALSE
PREDICT = TRUE

if(!exists("RESET"))
   RESET = TRUE

# Load libraries.
library(doParallel)
library(foreach)
library(caret)
library(fscaret)
library(beepr)

# Load supplementary code.
source("scripts/read_data.R")
source("scripts/feature_selection.R")
source("scripts/format_data.R")
source("scripts/partition_data.R")
source("scripts/train.R")
source("scripts/save.R")
source("scripts/time.R")
source("scripts/graph.R")
source("scripts/predict.R")

set.seed(1141)

# Register processor cores.
registerDoParallel(makeCluster(detectCores() - ignorecores))

if(RESET) {
   # Read data from file.
   read.data()
   
   # Format and partition data.
   partition.data(format.data(), outcomes, XXX, use.validation)
   
   # Reset the RESET flag, so this block isn't accidentally run twice in a row.
   RESET = FALSE
}

if(TRAIN) {     
   # Train models to analyze features.
   message("Training model/s for feature selection analysis...")
   sapply(outcomes, train.analysis)
   
   # Save workspace to disk.
   save.workspace()
}

if(ANALYZE) {
   # Analyze features with trained model.
   # For some reason, this part fails when called through 'sapply' function.
   message("Analyzing features...")
   analyze.features(test.data, test.outcomes, "SOC")
   analyze.features(test.data, test.outcomes, "pH")
   analyze.features(test.data, test.outcomes, "Ca")
   analyze.features(test.data, test.outcomes, "P")
   analyze.features(test.data, test.outcomes, "Sand")
   
   # TODO: Add code to automatically load .Rdf files into memory as list.
   # This was done manually.
   
   # Save workspace to disk.
   save.workspace()
}

if(GRAPH) {
   sapply(outcomes, graph.diffs)
}

if(RETRAIN) {
   train.models()
}

if(PREDICT) {
   #load.models("prediction")
   #make.predictions("prediction", test.data)
   
   model.rmse = NULL
   for(outcome in outcomes) {
      model.rmse[[outcome]] = sapply(predictions[[outcome]], rmse, test.outcomes[[outcome]])
   }
   rm(outcome)
   
   average.predictions = function(outcome.predictions, method.list=NULL) {
      avg = NULL
      
      # Cycle through all positions.
      for(pos in 1:length(outcome.predictions[[1]])) {
         sum = 0
         
         # Cycle through methods.
         if(is.null(method.list)) {
            for(method in 1:length(outcome.predictions)) {
               sum = sum + outcome.predictions[[method]][[pos]]
            }
         } else {
            for(method in method.list) {
               sum = sum + outcome.predictions[[method]][[pos]]
            }
         }
         avg[pos] = sum / length(outcome.predictions[[1]])
      }
      return(avg)
   }
   
   exclude.averages = average.predictions(predictions$SOC, methods[-1])
}

beep(8)