# Calculate the root mean squared error for a prediction vector.
rmse = function(predictions, true.values) {
   sqrt(sum((predictions - true.values)^2) / length(predictions))
}

# Make predictions on the given model and data.
predict.model = function(set, method, outcome, data) {
   if(set == "prediction") {
      return(predict(prediction.models[[outcome]][[method]], data))
   } else if(set == "analysis") {
      return(predict(analysis.models[[outcome]][[method]], data))
   } else {
      warning("Set type unknown. Choices are 'prediction' and 'analysis'.")
   }
}

# Make predictions for all models in a given model set, for the given data.
make.predictions = function(set="prediction", data) {
   if(!exists("predictions", inherits=T)) 
      predictions <<- NULL
   
   if(set == "prediction") {
      for(outcome in outcomes) {
         sapply(names(prediction.models[[outcome]]), 
                function(method) {predictions[[outcome]][[method]] <<- predict.model(set, method, outcome, data)})
      }
   } else if(set == "analysis") {
      warning("Functionality for 'make.predictions' not implemented for set 'analysis' yet. Get coding, monkey!!")
   } else {
      warning("Set type unknown. Choices are 'prediction' and 'analysis'.")
   }
}