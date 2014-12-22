cat("R code for predicting exercise type from WLE data\n\n")
# By Long You Cai (lycai), Dec 2014
# For the Johns Hopkins Practical Machine Learning course project.
#
# Optimised for the Groupware@LES Weight Lifting Exercises Dataset
#   Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H.
#   Qualitative Activity Recognition of Weight Lifting Exercises.
#   Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13).
#   Stuttgart, Germany: ACM SIGCHI, 2013.
#
# Usage:
# 1. Place csv training and test data into "pml-training.csv" and "pml-testing.csv" respectively,
#     and place files into working directory.
#     Alternatively, set pml.trainData and pml.testData variables to be the paths to the two files.
# 2. Call the script with `source('path-to-script-file/pml-main.R')`
# 3. ????
# 4. PROFIT!!!
# 5. You were done at step 2.
#
# Notes:
#   The reason why I didn't make this into a function was because I wanted easy access to both
#   the model and the results, to more easily analyse the data. If required, a simple function
#   wrapper with pml.[train/test]Data as arguments could be easily added.

# Setting default file paths/names
if (!exists("pml.trainData")) {
  pml.trainData = "pml-training.csv"
}
if (!exists("pml.testData")) {
  pml.testData = "pml-testing.csv"
}

set.seed(1)

cat("Loading libraries... ")
library(randomForest)

cat("Done!\nLoading and optimising training data... ")
# Read the first 5 rows and determine good columns (no NAs or timestamps, etc)
pml.5rows <- read.csv(pml.trainData, nrows = 5)
pml.goodcols <- sapply(pml.5rows, function(x) {!any(is.na(x))})
pml.goodcols[c("X", "user_name", "raw_timestamp_part_1", "raw_timestamp_part_2",
               "cvtd_timestamp")] <- FALSE

# Now apply good columns to the rest of the data
pml.train <- read.csv(pml.trainData)[, pml.goodcols]

cat("Done!\nTraining random forest model... ")
if (!exists("pml.rf")) {
  pml.rf <- randomForest(classe ~ ., pml.train) #, proximity = TRUE)
}
cat("Done!\n")

cat("Loading test data... ")
pml.test <- read.csv(pml.testData)[, pml.goodcols]
# Append to training data
if (any(colnames(pml.test) == "problem_id")) {
  colnames(pml.test)[colnames(pml.test) == "problem_id"] <- "classe"
}
pml.test$classe <- pml.train$classe[[1]]
pml.combined <- rbind(pml.test, pml.train[1:5,])

cat("Done!\nPredicting classes from test data... ")
pml.prediction <- predict(pml.rf, newdata = pml.combined[1:nrow(pml.test),])

cat("Done!\n\nThe random forest model is located in pml.rf. A logical array of the predictors used is in pml.goodcols.\n\n")
cat("The predicted classes for the test data shown below are located in pml.prediction:\n")
print(pml.prediction)
cat("\nHave a nice day!\n")