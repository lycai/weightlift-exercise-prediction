cat("R code for predicting exercise type from WLE data\n\n")
# By Long You Cai (lycai), Dec 2014
# For the Johns Hopkins Practical Machine Learning course project.
#
# Optimised for the Groupware@LES Weight Lifting Exercises Dataset
#   Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H.
#   Qualitative Activity Recognition of Weight Lifting Exercises.
#   Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13).
#   Stuttgart, Germany: ACM SIGCHI, 2013.

set.seed(1)

cat("Loading libraries... ")
library(randomForest)

cat("Done!\nLoading and optimising training data... ")
# Read the first 5 rows and determine good columns (no NAs or timestamps, etc)
pml.5rows <- read.csv("pml-training.csv", nrows = 5)
pml.goodcols <- sapply(pml.5rows, function(x) {!any(is.na(x))})
pml.goodcols[c("X", "user_name", "raw_timestamp_part_1", "raw_timestamp_part_2",
               "cvtd_timestamp")] <- FALSE

# Now apply good columns to the rest of the data
pml.train <- read.csv("pml-training.csv")[, pml.goodcols]

cat("Done!\nTraining random forest model... ")
if (!exists("pml.rf")) {
  pml.rf <- randomForest(classe ~ ., pml.train) #, proximity = TRUE)
}
cat("Done!\n")

cat("Loading test data... ")
pml.test <- read.csv("pml-testing.csv")[, pml.goodcols]
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