train.models = function(target, keepers) {
   models = c("rf")
   
   message(sprintf("Training %d models for the %s outcome...", length(models), target))
   
   begin = Sys.time()
   
   output = sapply(X=models, FUN=train, x=train.data[,keepers], y=train.outcomes[[target]], preProcess=c("center", "scale"))
   
   end = Sys.time()
   message(sprintf("Total time to train models: %d minutes %d seconds.", 
                   floor(as.numeric(end-begin, units="mins")), 
                   floor(as.numeric(end-begin, units="secs")) %% 60))
   
   return(output)
}