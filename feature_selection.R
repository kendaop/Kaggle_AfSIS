# Calculate the root mean squared error for a prediction vector.
calc.rmse = function(predictions, true.values) {
   sqrt(sum((predictions - true.values)^2) / length(predictions))
}

# Shuffle all of the values for one feature and returns the new data as a vector.
shuffle = function(x) {
   x[sample(length(x))]
}

# Print to the log file.
catf = function(...) {
   cat(..., "...", sep="", file="log.txt", append=TRUE, fill=T)
}

# The main function. Returns a data frame with the RMSEs.
analyze.features = function(newdata, newoutcomes, model) {
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
   
   cat("Time is: ", format(Sys.time(), "%a %b %d %X %Y"), "\r\n")
   cat("About to enter parallelization...\r\n")
   
   # Send output to a log file.
   writeLines("", "log.txt")
   
   start.timer()
   
   output = foreach(variable = names(newdata), .export=c("calc.rmse", "catf", "start.timer", "stop.timer"), .combine="rbind") %dopar% {
      baseline = NULL
      shuffle = NULL
      
      sdata = newdata
      
      catf("Analyzing ", variable)
      sdata[[variable]] = shuffled.data[[variable]]
      
      baseline[[variable]] = suppressWarnings(calc.rmse(predict(model, newdata=newdata), newoutcomes))
      shuffle[[variable]]  = suppressWarnings(calc.rmse(predict(model, newdata=sdata), newoutcomes))
      
      cbind(baseline=baseline, shuffle=shuffle)
   }
   
   stop.timer("Total time to analyze features")
   
   cat(names(output))
   
   # Reduce list of kept features.
   keep = row.names(output)[which(output[,2] - output[,1] > 0)]
   
   rm(output, shuffled.data)
   return(keep)
}