# Shuffle all of the values for one feature and returns the new data as a vector.
shuffle = function(x) {
   x[sample(length(x))]
}

# Print to the log file.
catf = function(...) {
   cat(..., "...", sep="", file="log.txt", append=TRUE, fill=T)
}

# Train a model by outcome name.
train.analysis = function(outcome) {
   cat(sprintf("Training %s model...\r\n", outcome))
   
   start.timer()
   fit = train(train.data, train.outcomes[[outcome]], method="lasso", preProcess=c("center", "scale"))
   stop.timer("Time to fit model")
   
   # Store model in Global environment and save to disk.
   analysis.models[[outcome]] <<- fit
   save.model(fit, paste(sprintf("FA_%s", outcome), sep=""))
   
   beep(1)
}

# The main function. Returns a list of the names of the features with positive RMSE change.
analyze.features = function(newdata, newoutcomes, model.name) {
   model = analysis.models[[model.name]]
   file = "data/shuffled_data.csv"
   
   if(!file.exists(file)) {
      cat("Creating shuffled data frame...\r\n")
      shuffled.data = as.data.frame(sapply(newdata, shuffle))
      
      cat("Writing shuffled data frame to disk...\r\n")
      write.csv(shuffled.data, file)
   } else {
      cat("Reading shuffled data from file...\r\n")
      shuffled.data = read.csv(file)
   }
   
   # Send output to a log file.
   writeLines("", "log.txt")
   
   start.timer("About to enter parallelization...")
   cat("Time is: ", format(Sys.time(), "%a %b %d %X %Y"), "\r\n")
   
   output = foreach(variable = names(newdata), .export=c("calc.rmse", "catf", "start.timer", "stop.timer"), .combine="rbind") %dopar% {
      baseline = NULL
      shuffle = NULL
      
      sdata = newdata
      
      # Write to log file.
      catf("Analyzing ", variable)
      
      sdata[[variable]] = shuffled.data[[variable]]
      
      baseline[[variable]] = suppressWarnings(calc.rmse(predict(model, newdata=newdata), newoutcomes))
      shuffle[[variable]]  = suppressWarnings(calc.rmse(predict(model, newdata=sdata), newoutcomes))
      
      cbind(baseline=baseline, shuffle=shuffle)
   }
   
   stop.timer("Total time to analyze features")
   
   save.df(output, paste("RMSE_", model.name, sep=""))
   
   # Reduce list of kept features.
   keep = row.names(output)[which(output[,2] - output[,1] > 0)]
   
   rm(output, shuffled.data)
   beep(1)
   return(keep)
}