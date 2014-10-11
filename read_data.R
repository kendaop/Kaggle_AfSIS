# Static variables.
zipfile1 = paste(getwd(), "/data/train.zip", sep="")
zipfile2 = paste(getwd(), "/data/test.zip", sep="")
xfile1 = "training.csv"
xfile2 = "sorted_test.csv"

# Unzip the zipped files, if they haven't been extracted yet.
if(!any(c(xfile1, xfile2) %in% list.files(getwd()))) {
   message("Unzipping training data...")
   unzip(zipfile1)
   message("Unzipping test data...")
   unzip(zipfile2)
} else message("Files already unzipped.")

# Read in the data.
if(!exists("raw.train", inherits=F)) {
   message("Reading in training data...")
   raw.train = read.csv(xfile1, header=T)
} else message("Data already read in to current environment.")

if(!exists("raw.test", inherits=F)) {
   message("Reading in test data...")
   raw.test = read.csv(xfile2, header=T)
} else message("Data already read in to current environment.")