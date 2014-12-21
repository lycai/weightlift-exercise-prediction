

set.seed(1)

library(caret)
pml.test <- read.csv("pml-testing.csv")
pml.train <- read.csv("pml-training.csv")

pml.train.imputed <- rfImpute(classe ~ ., pml.train)
pml.rf <- randomForest(classe ~ ., pml.train.imputed)

# noclass <- pmlTrain[, -160]
# 
# rfModel <- train(classe ~ ., data = pmlTrain, model = "rf", prox = TRUE)
# 
# centers <- classCenter(trainData, trainData$classe, rfModel$finalModel$prox)
# centers <- as.data.frame(centers)
# centers$classe <- rownames(centers)
# 
# p <- qplot(x, y, col = classe, data=pmlTrain)
# p + geom_point