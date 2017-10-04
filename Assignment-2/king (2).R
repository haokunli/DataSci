## House sales in King County (continuation) ##

# Reading data #
king <- read.csv("https://raw.githubusercontent.com/cinnData/DATA/master/Data/king.csv")

# Linear regression model (original scale) #
fm1 <- price ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors +
  waterfront + condition + sqft_above + yr_built + yr_renovated + lat + long
mod1 <- lm(formula=fm1, data=king)
summary(mod1)
pred1 <- predict(mod1, newdata=king)
error1 <- king$price - pred1
summary(error1)

# Linear regression model (log scale) #
fm2 <- log(price) ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors +
  waterfront + condition + sqft_above + yr_built + yr_renovated + lat + long
mod2 <- lm(formula=fm2, data=king)
summary(mod2)
pred2 <- exp(predict(mod2, newdata=king))
error2 <- king$price - pred2

# Comparison #
summary(error1)
summary(error2)
par(mfrow=c(1,2))
hist(error1, main="Figure 1a. Prediction error (1)", xlab="")
hist(error2, main="Figure 1b. Prediction error (2)", xlab="")
plot(king$price ~ pred1, pch=".", main="Figure 2a. Actual vs predicted price (1)",
 xlab="Predicted price", ylab="Actual price")
plot(king$price ~ pred2, pch=".", main="Figure 2b. Actual vs predicted price (2)",
  xlab="Predicted price", ylab="Prediction error")

# Trimming the data #
sum(king$price < 2*10^6)
king <- king[king$price < 2*10^6, ]
mod1 <- lm(formula=fm1, data=king)
summary(mod1)
pred1 <- predict(mod1, newdata=king)
error1 <- king$price - pred1
summary(error1)

# Including zipcode #
sort(unique(king$zipcode))
table(unique(substr(king$zipcode, 1, 4)))
fm3 <- price ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors +
  waterfront + condition + sqft_above +
  yr_built + yr_renovated + substr(zipcode, 1, 4)

# Time effects #
table(substr(king$date, 1, 6))
par(mfrow=c(1,1))
plot(tapply(king$price, substr(king$date, 1, 6), mean), type="l",
  main="Figure 3. Seasonality", xlab="Month", ylab="Price")
fm4 <- price ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors +
    waterfront + condition + sqft_above + yr_built + yr_renovated + lat +
    long + substr(king$date, 1, 6)
mod4 <- lm(formula=fm4, data=king)
summary(mod4)
