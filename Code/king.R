## House sales in King County ##

# Setting work directory #
setwd("/Users/miguel/Dropbox (IESE)/Data archive/DATA")

# Reading data #
king <- read.csv("king.csv", stringsAsFactors=F)
head(king)
summary(king)

# Formula #
fm <- price ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors +
  waterfront + condition + sqft_above + yr_built + yr_renovated + lat + long

# Linear regression #
mod <- lm(formula=fm, data=king)
summary(mod)
names(mod)
pred_price <- predict(mod, newdata=king)
pred_error <- king$price - pred_price
  plot(king$price ~ pred_price, pch=".", main="Figure 1", xlab="Predicted price",
  ylab="Actual price")

# Histograms #
par(mfrow=c(1,2))
hist(king$price, main="Figure 1a. Actual price", xlab="")
hist(pred_error, main="Figure 1b. Prediction error", xlab="")

# Scatterplots #
par(mfrow=c(1,2))
plot(king$price ~ pred_price, pch=20, main="Figure 2a. Actual vs predicted price",
 xlab="Predicted price", ylab="Actual price")
plot(pred_error ~ pred_price, pch=20, main="Figure 2b. Prediction error vs predicted price",
  xlab="Predicted price", ylab="Prediction error")



#Logarithmic scale #
fm_log <- log(price) ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors +
  waterfront + condition + sqft_above + 
  yr_built + yr_renovated + lat + long
model_log <- lm(formula=fm_log, data=king)
summary(model_log)
pred_price_log <- exp(predict(model_log, newdata=king))
hist(pred_price_log  - king$price)

# Including zipcode #
fm2 <- price ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors +
  waterfront + condition + sqft_above + 
  yr_built + yr_renovated + lat + long + substr(zipcode, 1, 4)
model2<- lm(formula=fm2, data=king)
summary(model2)

# Random forest #
library(randomForest)
N <- floor(nrow(king)/2)
train <- sample(1:N, nrow(king)/2,  replace=F)
mod6 <- randomForest(formula=fm, data=king[train,], ntree=500, nodesize=0.01*N, importance=T) 
pred6_train <- predict(mod6, newdata=king[train,])
pred6_test <- predict(mod6, newdata=king[-train,])
cor(pred6_train, king$price[train])
cor(pred6_test, king$price[-train])
