# Session variables.
setwd("C:/Users/K-Dawg/Documents/Git/Kaggle_AfSIS")
ignorecores = 1
use.validation = FALSE
TRAIN = FALSE
ANALYZE = FALSE
RETRAIN = FALSE
TARGET = "SOC"

if(!exists("RESET"))
   RESET = TRUE

# Load libraries.
library(doParallel)
library(foreach)
library(caret)
library(fscaret)
library(beepr)

# Load supplementary code.
source("read_data.R")
source("feature_selection.R")
source("format_data.R")
source("partition_data.R")
source("train.R")
source("save.R")

set.seed(1141)

# Register processor cores.
registerDoParallel(makeCluster(detectCores() - ignorecores))

if(RESET) {
   # Read data from file.
   read.data()
   
   # Format and parition data.
   partition.data(format.data(), outcomes, TARGET, use.validation)
   
   # Reset the RESET flag, so this block isn't accidentally run twice in a row.
   RESET = FALSE
}

if(TRAIN) {   
   # Train model to analyze features.
   message("Training model/s for feature selection analysis...")
   
   start.timer()
   lasso = train(train.data, train.outcomes$SOC, method="lasso", preProcess=c("center", "scale"))
   stop.timer("Total time to train model")
   
   # Save workspace to disk.
   save.workspace()
}

if(ANALYZE) {
   # Analyze features with trained model.
   message("Analyzing features...")
   keep = analyze.features(test.data, test.outcomes, lasso)
   
   # Save workspace to disk.
   save.workspace()
}

if(RETRAIN) {
   fits = sapply(outcomes, train.models, keep)
}

beep(8)