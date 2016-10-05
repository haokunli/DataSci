## Bike rental assignment -> Prediction of "casual" renting

# Reading data
BikeDataFrame <- read.csv(file="https://raw.githubusercontent.com/cinnData/DATA/master/TeamProject-1/bike.csv",
  stringsAsFactors=FALSE)

# Replacing column datetime with hour and change it to factor
BikeDataFrame$month <- substr(BikeDataFrame$datetime, 6, 7)
BikeDataFrame$month <- factor(BikeDataFrame$month)
BikeDataFrame$datetime <- substr(BikeDataFrame$datetime, 12, 13)
BikeDataFrame$datetime <- factor(BikeDataFrame$datetime)

# Creation of a unique column using the holiday and working day column 
# 3 posibilities week-end, working day, holiday
# include verification
table(BikeDataFrame$holiday, BikeDataFrame$workingday)
BikeDataFrame$period <- ifelse(BikeDataFrame$workingday == 1 ,"workingday",
  ifelse(BikeDataFrame$holiday == 0, "weekend", "holiday"))
table(BikeDataFrame$period)
BikeDataFrame$period <- factor(BikeDataFrame$period)

# Linear regression datetime + month + period + weather + atemp 
fm1 <- casual ~ datetime + month + period + weather + atemp 
mod1 <- lm(formula=fm1, data=BikeDataFrame) 
summary(mod1)
pred1 <- predict(mod1, data=BikeDataFrame)

# Plot the casual graph to compare with aggregate demand
plot(tapply(BikeDataFrame$casual, BikeDataFrame$datetime, mean))
