# Reading data
airlines <- read.csv("E:/airlines.csv", stringsAsFactors = F)
airports <- read.csv("E:/airports.csv", stringsAsFactors = F)
flights <- read.csv("E:/flights.csv", stringsAsFactors = F)

# Omit missing values
flights <- na.omit(flights)

# Create delay column in fligths - 1 if delay is more than 15 minutes
flights$DELAY <- as.numeric(flights$dep_delay>15)


# Analysis of Data
###########################

# Analysis of carriers - there are 7 carriers out of 16
# that operates less  than 6000 fligths AS,F9,FL,HA,OO,VX,YV
# 9 carriers carry 316750 of the fligths
airlines
plot(factor(flights$carrier))
sort(table(flights$carrier))
key_carriers <- names(which(table(flights$carrier)>6000))
key_carriers

#Analysis of most frequent airports - only 9 airports with more than 10000 destination flights
plot(sort(table(flights$dest), decreasing=T))
key_dest <- names(which(table(flights$dest)>10000))
key_dest

# New flight table with only 9 carriers and 9 destinations
flights2 <- flights[flights$carrier %in% key_carriers &
  flights$dest %in% key_dest ,]
dim(flights2)

# Analysis of delays - there are 23189 delays out of 121485 fligths(21%)
# % delays on main carriers varies from almost 7% to 31% - HUGE DIFFERENCE!!!
sum(flights2$DELAY)
sort(tapply(flights2$DELAY, flights2$carrier, mean))

# % delays on main destination varies from 16% to 22% -
# Indication: It is more an issue of carriers than destinations
sort(tapply(flights2$DELAY, flights2$dest, mean))

# Graph showing delays by route and key carriers
table(flights2$origin, flights2$dest)
route <- paste(flights2$origin,flights2$dest,sep = " - ")
table(route, flights2$carrier)
sort(tapply(flights2$DELAY, paste(route,flights2$carrier, sep = " - "),
  mean), decreasing = T)
plot(sort(tapply(flights2$DELAY, paste(route,flights2$carrier, sep = "-"),
  mean), decreasing = T))


#Create the regression model
#############################

# Model -we run the simmulation on fligths3(just 9 carriers(>6000 fligths) and 9 destinations(>5000 fligths))

# Cutoff difinition
cutoff <- 0.2

# Create variables
month<- substr(flights2$datetime,6,7)
hour<- substr(flights2$datetime,12,13)
weekday<- weekdays(as.Date(flights2$datetime))
head(weekday)

# Formula & Model
fm <- DELAY ~ month + hour + weekday + carrier + route
mod1 <- glm(formula=fm, data=flights2, family=binomial)
pred1 <- predict(mod1,newdata=flights2, type="response")
conf1 <- table(pred1 > cutoff, flights2$dep_delay > cutoff)
conf1
tp1 <- conf1["TRUE", "TRUE"]/sum(conf1[,"TRUE"])
tp1
fp1 <- conf1["TRUE", "FALSE"]/sum(conf1[,"FALSE"])
fp1 
hist(pred1)

#Check model with a tree
#############################

library(rpart)
mod2 <- rpart(formula=fm, data=flights2, cp=0.001)
mod2
pred2 <- predict(mod2,newdata=flights2)
conf2 <- table(pred2 > cutoff, flights2$dep_delay > cutoff)
conf2
tp2 <- conf2["TRUE", "TRUE"]/sum(conf1[,"TRUE"])
tp2 
fp2 <- conf2["TRUE", "FALSE"]/sum(conf1[,"FALSE"])
fp2 