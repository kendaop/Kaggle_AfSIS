setwd("C:/Users/K-Dawg/Documents/Git/Kaggle_AfSIS")

# Load libraries and supplementary code.
library(doParallel)
library(caret)
library(leaps)
source("read_data.R")
source("feature_selection.R")
source("partition_data.R")

# Session variables.
ignorecores = 1
use.validation = FALSE

# Static variables.
outcomes = c("SOC", "pH", "Ca", "P", "Sand")
ignore = "PIDN"

# Register processor cores.
suppressWarnings(registerDoParallel(makeCluster(detectCores() - ignorecores)))

set.seed(1141)

message("Formatting data...please wait.")

# Specify which features to ignore.
ignore = c(ignore, ignore.samples())

# Re-order data to remove geographical bias.
train = data[sample(nrow(data)), !(names(data) %in% ignore)]
row.names(train) = 1:nrow(train)

# Convert factor variables to numerics.
train$Depth = as.numeric(train$Depth) - 1

message("Data formatted.")

message("Running ")
regsubsets(x=train[,!(names(train) %in% c(outcomes, ignore))], y=train[,"SOC"], really.big=T)
#select.features(outcomes[1])