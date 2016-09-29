## San Francisco home sales ##

# Importing data to R
frisco <- read.csv("/Users/JoyceLee/Desktop/Term_4/DATA_SCIENCE/frisco.csv")
str(frisco)

# Exploring missing values
summary(frisco)
sum(is.na(frisco$lotsize))
sum(is.na(frisco$squarefeet))
sum(is.na(frisco$squarefeet)*is.na(frisco$lotsize))
sum(is.na(frisco$bedrooms))
sum(is.na(frisco$squarefeet)*is.na(frisco$bedrooms))

# Predictive power of size variables
summary(lm(price ~ bedrooms + squarefeet + lotsize, data=frisco))$r.squared
summary(lm(price ~ squarefeet, data=frisco))$r.squared

# Exploring neighborhood
sort(tapply(frisco$price, frisco$neighborhood, mean))
table(frisco$neighborhood)
summary(lm(price ~ neighborhood, data=frisco))$r.squared

# Exploring zip
sort(tapply(frisco$price, frisco$zip, mean))
table(frisco$zip)
summary(lm(price ~ factor(zip), data=frisco))$r.squared

# Exploring month
tapply(frisco$price, frisco$month, mean)
summary(lm(price ~ month, data=frisco))$r.squared

# Regression models
fm <- price ~ month + squarefeet + neighborhood
mod <- lm(formula=fm, data=frisco)
summary(mod)
