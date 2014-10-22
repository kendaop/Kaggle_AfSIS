train.model = function(set, method, outcome) {
   if(set == "prediction") {
      if(!file.exists(sprintf("models/Pred_%s_%s.RMod", method, outcome))) {
         start.timer(sprintf("Training %s model for %s outcome...", method, outcome))   
         
         fit = train(subset(train.data, select=keep[[outcome]]), 
                                    train.outcomes[[outcome]], 
                                    method=method, 
                                    preProcess=c("center", "scale"))
         
         stop.timer("Time to train model")
         
         # Save model to disk.
         save.model(fit, sprintf("Pred_%s_%s", method, outcome))
      }
   } else if(set == "analysis") {
      if(!file.exists(sprintf("models/FA_%s_%s.RMod", method, outcome))) {
         start.timer(sprintf("Training %s model for %s outcome...", method, outcome))   
         
         fit = train(subset(train.data, select=keep[[outcome]]), 
                     train.outcomes[[outcome]], 
                     method=method, 
                     preProcess=c("center", "scale"))
         
         stop.timer("Time to train model")
         
         # Save model to disk.
         save.model(fit, sprintf("FA_%s_%s", method, outcome))
      }
   } else {
      warning("Set type unknown. Choices are 'prediction' and 'analysis'.")
   }
   beep(1)
}

# Train list of models for given outcome.
train.models = function(set="prediction") {   
   for(outcome in outcomes) {
      sapply(methods, train.model, set=set, outcome=outcome)
   }
}

