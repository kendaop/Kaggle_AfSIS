ignore.samples = function() {
   names(which(sapply(names(raw.train), FUN = 
            function(name){
               measurement = ifelse(substr(name, 1, 1) != "m", FALSE, as.numeric(substr(name, 2, nchar(name))))
               ifelse(measurement >= 2352.76 & measurement <= 2379.76, TRUE, FALSE)
            }) == TRUE
   ))
}

rmse = function(predictions, true.values) {
   sqrt(sum((predictions - true.values)^2) / length(predictions))
}

# Shuffles all of the values for one feature and returns the new data frame.
shuffle.variable = function(variable, data) {
   newvar = data[[variable]][sample(length(data[[variable]]))]
   data[[variable]] = newvar
   return(data)
}

analyze.features = function(newdata, newoutcomes, model) {
   baseline.rmse <<- NULL
   shuffle.rmse  <<- NULL
   
   suppressWarnings(registerDoParallel(makeCluster(detectCores() - ignorecores)))
   begin = Sys.time()
   
   for(variable in names(newdata)) {
      baseline.rmse[[variable]] <<- suppressWarnings(rmse(predict(model, newdata=newdata), newoutcomes))
      shuffle.rmse[[variable]]  <<- suppressWarnings(rmse(predict(model, newdata=shuffle.variable(variable, newdata)), newoutcomes))
   }
   
   end = Sys.time()
   message(sprintf("Total time to analyze features: %d minutes %d seconds.", 
                   floor(as.numeric(end-begin, units="mins")), 
                   floor(as.numeric(end-begin, units="secs")) %% 60))
}

# Specify which features to ignore and keep.
ignore = c(ignore, outcomes, ignore.samples())
keep = names(raw.train)[!(names(raw.train) %in% ignore)]