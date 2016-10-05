###### Team Assignment 1: Bike Sharing
###### Team: Enrique Gonzalez, Pol Tarrago, Osamu Fujishiro, Sayoko Kaide
##### Analysis of bike sharing service demand in Washington DC

##### Read csv file
bikedata <- read.csv(file="https://raw.githubusercontent.com/cinnData/DATA/master/TeamProject-1/bike.csv")
## check 
str(bikedata)

##### Take out only month & hour data from bikedata$datetime
library(lubridate)
bikedata$datetime <- as.POSIXlt(bikedata$datetime)
## check
str(bikedata$datetime)
bikedata$hour <- hour(bikedata$datetime)
bikedata$month <- month(bikedata$datetime)
## check
str(bikedata$hour)
str(bikedata$month)

##### Analysis of bikedata
### How much overlap is there for holiday & workingday?
table(bikedata$holiday, bikedata$workingday)

## Season
plot(tapply(bikedata$count, bikedata$season, mean), ylab = "Average Count")

## Holiday
tapply(bikedata$count, bikedata$holiday, mean), ylab = "Average Count")

## Workingday
tapply(bikedata$count, bikedata$workingday, mean)

## Weather
tapply(bikedata$count, bikedata$weather, mean)
# Weather "4" seems odd...How many "4" are there?
table(bikedata$weather)
# There is only one "4", so we merge "4" with "3"
3 -> bikedata$weather[bikedata$weather == 4]

## Temperature
# temp & atemp are very similar, what's the correlation?
cor(bikedata$temp, bikedata$atemp)
# -> Correlation is very high, so we only use one of these.

## Month
plot(tapply(bikedata$count, bikedata$month, mean), ylab = "Average Count")
# -> This is almost the same as season, so just keeping season would be simpler.

## Hour
plot(tapply(bikedata$count, bikedata$hour, mean), ylab = "Average Count")
# -> There are peaks in the morning and the afternoon.

##### Calculating R for each variables
summary(lm(count ~ season, data=bikedata))$r.squared
summary(lm(count ~ holiday + workingday, data=bikedata))$r.squared
summary(lm(count ~ factor(weather), data=bikedata))$r.squared
summary(lm(count ~ temp, data=bikedata))$r.squared
summary(lm(count ~ humidity, data=bikedata))$r.squared
summary(lm(count ~ windspeed, data=bikedata))$r.squared
summary(lm(count ~ factor(month), data=bikedata))$r.squared
summary(lm(count ~ factor(hour), data=bikedata))$r.squared
# -> hour, temp, humidity seems to have high R

##### Linear regression with hour, temp, and humidity
fm1 <- count ~ factor(hour) + temp + humidity 
mod1 <- lm(formula=fm1, data=bikedata)
summary(mod1)$r.square

##### Linear regression with hour, temp, humidity, month
fm2 <- count ~ factor(hour) + factor(month) + holiday + workingday + temp + humidity 
mod2 <- lm(formula=fm2, data=bikedata)
summary(mod2)$r.square
