not.named = function(names, data) {
   data[, -which(names(data) %in% names)]
}
   
format.data = function() {   
   if(!exists("data", inherits=F)) {
      message("Formatting data...")
      
      # Re-order data to remove geographical bias.
      data = raw.train[sample(nrow(raw.train)), c(keep, outcomes)]
      row.names(data) = 1:nrow(data)
      
      # Convert factor variables to numerics.
      data$Depth = as.numeric(data$Depth) - 1  
      
      rm(raw.train, inherits=T)
      return(data)
   } else 
      message("Data already formatted.")
}