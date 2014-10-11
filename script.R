# Session variables.
setwd("C:/Users/K-Dawg/Documents/Git/Kaggle_AfSIS")
ignorecores = 2
use.validation = FALSE
TRAIN = TRUE
ANALYZE = TRUE

# Static variables.
outcomes = c(green="SOC", blue="pH", orange="Ca", red="P", purple="Sand")
ignore = "PIDN"

# Load libraries and supplementary code.
library(doParallel)
library(caret)
library(fscaret)
library(leaps)
library(beepr)
source("read_data.R")
source("feature_selection.R")
source("format_data.R")
source("partition_data.R")

set.seed(1141)

if(TRAIN) {
   # Register processor cores.
   suppressWarnings(registerDoParallel(makeCluster(detectCores() - ignorecores)))

   # Run feature selection.
   message("Partitioning data for feature selection analysis...")
   partition.data(data, outcomes, "SOC", F)
   
   # Train model to analyze features.
   message("Training model for feature selection analysis...")
   lm = train(train.data, train.outcomes$SOC, method="lm", preProcess=c("center", "scale"))
}

if(ANALYZE & TRAIN) {
   # Analyze features with trained model.
   message("Analyzing features...")
   analyze.features(test.data, test.outcomes, lm)
}

plot(1:length(baseline.rmse), baseline.rmse, col="blue", type="l")
lines(1:length(shuffle.rmse), shuffle.rmse, col="red", type="l")

beep(8)