## Windsor housing prices (log scale) ##

# Reading data
windsor <- read.csv(file="E:/windsor.csv")

# Linear regression model #
fm1 <- price ~ lotsize + nbdrm + nbhrm + nstor + ngar + drive + recrm +
  base + gas + air + neigh  
mod1 <- lm(formula=fm1, data=windsor)
summary(mod1)

# Statistical evaluation of the model #
pred1 <- predict(mod1, newdata=windsor)
res1 <- windsor$price - pred1
sd(res1)
sd(windsor$price)
sd(res1)/sd(windsor$price)

# Comparing distributions #
par(mfrow=c(1,2))
hist(windsor$price, main="", xlab="Price")
hist(log(windsor$price), main="", xlab="Log price")

# Linear regression model (log scale) #
fm2 <- log(price) ~ lotsize + nbdrm + nbhrm + nstor + ngar + drive + recrm +
  base + gas + air + neigh  
mod2 <- lm(formula=fm2, data=windsor) 
summary(mod2)
pred2 <- exp(predict(mod2, newdata=windsor))
res2 <- windsor$price - pred2
sd(res2)
sd(windsor$price)
sd(res2)/sd(windsor$price)
