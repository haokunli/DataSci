## [DATA-01] Regression and classification ##

# Setting work directory
setwd("/Users/miguel/Dropbox (Personal)/Current jobs/DATA-2016/DATA-01")

# Reading data
windsor <- read.table("windsor.dat", sep="|", header=TRUE)
dim(windsor)
head(windsor)
N <- nrow(windsor)

# Linear regression model
fm1 <- price ~ lotsize + nbdrm + nbhrm + nstor + ngar + drive + recrm + base + gas + air + neigh  
fm1 <- price ~ .  ##  the same but be careful with transformations
mod1 <- lm(formula=fm1, data=windsor) 
summary(mod1)  ##  details about the model

# Evaluating the linear regression model
pred1 <- predict(mod1, newdata=windsor)
res1 <- windsor$price - pred1
sd(res1)
sd(windsor$price)
sd(res1)/sd(windsor$price)
mean(abs(res1)>40000)

# Figure 2
par(mfrow=c(1,2))
hist(windsor$price, main="", xlab="Price")
hist(res1, main="", xlab="Prediction error")

# Log transformation
fm2 <- log(price) ~ lotsize + nbdrm + nbhrm + nstor + ngar + drive + recrm + base +
  gas + air + neigh
mod2 <- lm(formula=fm2, data=windsor) 
summary(mod2)

# Evaluating the alternative regression model
pred2 <- exp(predict(mod2, newdata=windsor))
cor(windsor$price, pred2)
res2 <- windsor$price - pred2
sd(res2)
sd(res2)/sd(windsor$price)
mean(abs(res2)>40000)

# Figure 3
par(mfrow=c(1,2))
hist(log(windsor$price), main="", xlab="Price (log scale)")
hist(res2, main="", xlab="Prediction error")
