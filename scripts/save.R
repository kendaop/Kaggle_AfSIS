save.workspace = function(filename="ws/workspace.RData") {
   message(sprintf("Saving workspace to '%s'...", filename))
   save.image(filename, safe=TRUE)
}

load.workspace = function(filename="ws/workspace.RData") {
   message(sprintf("Loading workspace '%s'...", filename))
   load(filename)
}

save.model = function(model, filename) {
   save("model", file=sprintf("models/%s.RMod", filename))
}

load.model = function(set, method, outcome) {
   if(set == "prediction") {
      if(!exists("prediction.models", inherits=T))
         prediction.models <<- NULL
      
      load(sprintf("models/Pred_%s_%s.RMod", method, outcome))
      prediction.models[[outcome]][[method]] <<- model
      
      rm(model)
   } else if(set == "analysis") {
      if(!exists("analysis.models", inherits=T))
         analysis.models <<- NULL
      
      load(sprintf("models/FA_%s_%s.RMod", method, outcome))
      analysis.models[[outcome]][[method]] <<- model
      rm(model)
   } else {
      warning("Unrecognized 'set' parameter. Choices are 'prediction' and 'analysis'.")
   }
}

load.models = function(set="prediction") {
   message(sprintf("Loading %s models from disk...", set))
   
   for(outcome in outcomes) {
      sapply(methods, load.model, set=set, outcome=outcome)
   }
}

save.df = function(df, filename) {
   save("df", file=sprintf("data/%s.Rdf", filename))
}

load.df = function(filename) {
   load(sprintf("data/%s.Rdf", filename))
}