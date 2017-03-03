weather <- read.csv("https://raw.githubusercontent.com/cinnData/DATA/master/Data/weather.csv",
                    stringsAsFactors=F)
flights <- read.csv("https://raw.githubusercontent.com/cinnData/DATA/master/Data/flights.csv",
                    stringsAsFactors=F)
airlines <- read.csv("https://raw.githubusercontent.com/cinnData/DATA/master/Data/airlines.csv",
                    stringsAsFactors=F)
airports <- read.csv("https://raw.githubusercontent.com/cinnData/DATA/master/Data/airports.csv",
                    stringsAsFactors=F)

# Check data quality
summary(weather)

# Drop wind_gust and pressure
weather <- weather[,-c(8,10)]
summary(weather)

# Omit all NAs in weather and in flights
weather <- na.omit(weather)
flights <- na.omit(flights)

# Reduce flight dataset to only key carriers and destinations 
# 7 carriers out of 16 operate less than 6000 fligths 
# whereas 9 carriers carry 316750 of the fligths)
key_carriers <- names(which(table(flights$carrier)>6000))
key_carriers

# Reduce airport dataset to most frequent airports 
# only 9 airports with more than 10000 destination flights
key_dest <- names(which(table(flights$dest)>10000))
key_dest

# New flight table with only 9 carriers and 9 destinations
flights2 <- flights[flights$carrier %in% key_carriers & flights$dest %in% key_dest ,]
dim(flights2)

# Combine 2 files based on datetime & origin column
flights2_weather <- merge(flights2, weather)
str(flights2_weather)

# Run logistic regression
flights2_weather$delay15 <- as.numeric(flights2_weather$dep_delay > 15)
month<- substr(flights2_weather$datetime,6,7)
hour<- substr(flights2_weather$datetime,12,13)
weekday<- weekdays(as.Date(flights2_weather$datetime))
route <- paste(flights2_weather$origin,flights2_weather$dest,sep = " - ")

# From last class
fm <- delay15 ~ month + hour + weekday + carrier + route
mod <- glm(formula =fm, data=flights2_weather, family="binomial")
pred <- predict(mod, newdata = flights2_weather, type = "response")
hist(pred)
cut <- 0.2
conf <- table(pred > cut, flights2_weather$delay15 == 1)
conf
tp <- conf["TRUE","TRUE"]/sum(conf[,"TRUE"])
tp
fp <- conf["TRUE","FALSE"]/sum(conf[,"FALSE"])
fp

# Adding weather 
fm_lg <- delay15 ~ month + hour + weekday + carrier + route + temp + dewp + humid +
  wind_dir + wind_speed + precip + visib
mod_lg <- glm(formula=fm_lg, data=flights2_weather, family="binomial")
pred_lg <- predict(mod_lg, newdata=flights2_weather, type="response")
hist(pred_lg)

# Choose the cutoff
cut1 <- 0.2
conf1 <- table(pred_lg > cut1, flights2_weather$delay15 > cut1); conf1
tp1 <- conf1["TRUE","TRUE"]/sum(conf1[,"TRUE"])
tp1
fp1 <- conf1["TRUE","FALSE"]/sum(conf1[,"FALSE"])
fp1
#TP/(TP+FN) = TP rate among delays how many are we predicting. want TP to be high
#FP/(FN+TN) = FP needs to be low, however, this is not spam, false alarm is okay.
#adding weather actually decrease tp & increase fp

# Choose the cutoff
cut2 <- 0.15
conf2 <- table(pred_lg > cut2, flights2_weather$delay15 > cut2); conf2
tp2 <- conf2["TRUE","TRUE"]/sum(conf2[,"TRUE"])
tp2
fp2 <- conf2["TRUE","FALSE"]/sum(conf2[,"FALSE"])
fp2
#TP/(TP+FN) = TP rate among delays how many are we predicting. want TP to be high
#FP/(FN+TN) = FP needs to be low, however, this is not spam, false alarm is okay.
#Cutoff .15 is better than .2, since the TP rate is higher (.78 vs. .67). 
# This measures % of flights we can predict accurately that are delayed.

# Checking decision tree model
# Check cutoff = 0,2
library(rpart)
mod2 <- rpart(formula=fm_lg, data=flights2_weather, cp=0.001)
mod2
pred3 <- predict(mod2, newdata=flights2_weather)
hist(pred3)
conf3 <- table(pred3 > cut1, flights2_weather$delay15 > cut1)
conf3
tp3 <- conf3["TRUE", "TRUE"]/sum(conf3[,"TRUE"])
tp3
fp3 <- conf3["TRUE", "FALSE"]/sum(conf3[,"FALSE"])
fp3 

# Check cutoff = 0.15
conf4 <- table(pred3 > cut2, flights2_weather$delay15 > cut2)
conf4
tp4 <- conf4["TRUE", "TRUE"]/sum(conf4[,"TRUE"])
tp4
fp4 <- conf4["TRUE", "FALSE"]/sum(conf4[,"FALSE"])
fp4
