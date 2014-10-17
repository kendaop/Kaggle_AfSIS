# Returns vector of feature names which lie in the spectrum to be ignored.
ignore.samples = function() {
   names(which(sapply(names(raw.train), FUN = 
                         function(name){
                            measurement = ifelse(substr(name, 1, 1) != "m", FALSE, as.numeric(substr(name, 2, nchar(name))))
                            ifelse(measurement >= 2352.76 & measurement <= 2379.76, TRUE, FALSE)
                         }) == TRUE
   ))
}

read.data = function() {
   # Static variables.
   zipfile1 = paste(getwd(), "/data/train.zip", sep="")
   zipfile2 = paste(getwd(), "/data/test.zip", sep="")
   xfile1 = "training.csv"
   xfile2 = "sorted_test.csv"
   
   # Unzip the zipped files, if they haven't been extracted yet.
   if(!any(c(xfile1, xfile2) %in% list.files(paste(getwd(), "/data", sep="")))) {
      message("Unzipping training data...")
      unzip(zipfile1, exdir="./data")
      message("Unzipping test data...")
      unzip(zipfile2, exdir="./data")
   } else message("Files already unzipped.")
   
   # Read in the data.
   if(!exists("raw.train", inherits=F)) {
      message("Reading in training data...")
      raw.train <<- read.csv(paste("./data/", xfile1, sep=""), header=T)
   } else message("Data already read in to current environment.")
   
   if(!exists("raw.test", inherits=F)) {
      message("Reading in test data...")
      raw.test <<- read.csv(paste("./data/", xfile2, sep=""), header=T)
   } else message("Data already read in to current environment.")
   
   # Static variables.
   outcomes <<- c(green="SOC", blue="pH", orange="Ca", red="P", purple="Sand")
   ignore <<- c("PIDN", outcomes, ignore.samples())
   keep <<- names(raw.train)[!(names(raw.train) %in% ignore)]
   
   rm(zipfile1, zipfile2, xfile1, xfile2)
}