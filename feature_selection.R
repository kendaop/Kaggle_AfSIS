ignore.samples = function() {
   names(which(sapply(names(data), FUN = 
            function(name){
               measurement = ifelse(substr(name, 1, 1) != "m", FALSE, as.numeric(substr(name, 2, nchar(name))))
               ifelse(measurement >= 2352.76 & measurement <= 2379.76, TRUE, FALSE)
            }) == TRUE
   ))
}

select.features = function(outcome) {
   model = formula(outcome ~ .)
   regsubsets(model, y=data.matrix(data[,!(names(data) %in% outcomes)]), data[,outcome], method="Cp", really.big=T, data=data)
}