## House sales in King County ##

# Setting work directory (customize) #
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
