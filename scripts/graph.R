graph.diffs = function(outcome) {
   if(!exists("keep", inherits=T)) {
      keep <<- NULL
   }
   
   # Calculate differences in RMSE values.
   diffs = setNames(rmse[[outcome]]$shuffle - rmse[[outcome]]$baseline, rownames(rmse[[outcome]]))
   
   # Remove differences of zero.
   diffs = diffs[which(diffs > 0)]
   
   # Remove lower three quartiles of differences.
   diffs = diffs[which(diffs >= quantile(diffs)[["75%"]])]
   
   # Plot remaining differences.
   plot(1:length(diffs), diffs, 
        type="l", 
        col=names(outcomes[which(outcomes == outcome)])
        )
   
   # Write rownames to be kept to a global list.
   keep[[outcome]] <<- names(diffs)
   
   diffs
}