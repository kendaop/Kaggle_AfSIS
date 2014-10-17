start.timer = function() {
   if(exists("begin", inherits=T)) { 
      rm("begin", inherits=T)
      stop("Nested timer.")
   } else {
      begin <<- Sys.time()
   }
}

stop.timer = function(label=NULL) {
   end = Sys.time()
   
   if(is.null(label))
      label = "Total time"
   
   output = sprintf("%s: %d minutes %d seconds.", 
                    label,
                    floor(as.numeric(end-begin, units="mins")), 
                    floor(as.numeric(end-begin, units="secs")) %% 60)
   
   message(output)
   rm("begin", "end", "label", inherits=T)
   
   output
}