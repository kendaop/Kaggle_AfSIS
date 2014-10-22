start.timer = function(label="Starting timer...") {
   message(label)
   begin <<- Sys.time()
   
   if(exists("begin", inherits=T))
      warning("Nested timer. Final time may be innaccurate!")
}

stop.timer = function(label="Total time") {
   end = Sys.time()
   
   output = sprintf("%s: %d minutes %d seconds.", 
                    label,
                    floor(as.numeric(end-begin, units="mins")), 
                    floor(as.numeric(end-begin, units="secs")) %% 60)
   
   message(output)
   rm("begin", "end", "label", inherits=T)
   
   output
}