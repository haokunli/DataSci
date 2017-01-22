## Windsor housing prices ##

# Setting work directory (customize) #
setwd("/Users/miguel/Dropbox (Personal)/Current jobs/DATA-2017-1/DATA-02")

# Reading data
windsor <- read.csv(file="windsor.csv")

# Checks #
dim(windsor)
head(windsor)
tail(windsor)
str(windsor)

# Linear regression model #
fm <- price ~ lotsize + nbdrm + nbhrm + nstor + ngar + drive + recrm +
  base + gas + air + neigh  
mod <- lm(formula=fm, data=windsor) 

# Exploring the model #
names(mod)
summary(mod)

# Statistical evaluation of the model #
pred <- predict(mod, newdata=windsor)
res <- windsor$price - pred
sd(res)
sd(windsor$price)
sd(res)/sd(windsor$price)

# Evaluation in dollar terms #
mean(abs(res)>40000)

# Figure #
par(mfrow=c(1,2))
hist(windsor$price, main="", xlab="Price")
hist(res, main="", xlab="Prediction error")
