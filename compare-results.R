library(rpart)
library(caret)
library(rpart.plot)

data(iris)
index <- sample(1:nrow(iris), size=0.2*nrow(iris))
test <- iris[index, ]
train <- iris[-index, ]

# Build the model on raw data for a sanity check.
model <- rpart(Species~Sepal.Length+Sepal.Width+Petal.Length+Petal.Width, method="class", data=train)    
pred <- predict(model, test[, 1:4], type="class")

# The confusion matrix below shows an accuracy of 0.90.
confusionMatrix(pred, test[, 5])

# Now do the PCA part for classification
pca <- prcomp(train[, 1:4], scale.=T, center=T) # <---- NOTE if we change this to F, we get better performance

# "Fit" the test data into Z-space based on the loadings (or rotations) from the training.
test.zspace <- predict(pca, newdata=test[, 1:4])
pca.train.df <- as.data.frame(pca$x)
pca.train.df$Species <- train[, 5]

# Build the model on the PCs.
pca.model <- rpart(Species ~ ., method="class", data=pca.train.df)

pca.test.df <- as.data.frame(test.zspace)
pca.test.df$Species <- test[, 5]
pca.pred <- predict(pca.model, pca.test.df[, 1:4], type="class")

# Confusion matrix below shows an accuracy of 0.83.  If I do NOT center the data during prcomp(), it will show 0.90.
confusionMatrix(pca.pred, test[, 5])


mean(pred == test[, 5])
ind <- sample(length(pred), replace = TRUE)

rep1 <- replicate(1e4, {
  ind <- sample(length(pred), replace = TRUE)
  mean(pca.pred[ind] == test[ind, 5])
})

rep2 <- replicate(1e4, {
  ind <- sample(length(pred), replace = TRUE)
  mean(pred[ind] == test[ind, 5]) 
})

boxplot(cbind(rep1, rep2))