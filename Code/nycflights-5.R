# Reading data
planes <- read.csv("https://raw.githubusercontent.com/cinnData/DATA/master/Data/planes.csv",
                   stringsAsFactors=F)

# Checking data of planes
summary(planes)

# Reduce non-commercial planes by removing those with less than 40 seats
hist(planes$seats)
planes <- planes[planes$seats > 20, ]
dim(planes)

# Drop speed as 3299 out of 3322 are N/A 
# Drop type since it only has one value
# Drop engines since it takes always the same value except for 5 planes
# Drop model because it is too scattered
table(planes$type)
table(planes$engines)
table(planes$model)
planes <- planes[, -c(3,5,6,8)]
summary(planes)

# Drop one row where engine takes a singular value
table(planes$engine)
planes <- planes[planes$engine!="Reciprocating", ]

# Grouping same manufacturers with different names and simplifying
table(planes$manufacturer)
planes$manufacturer[planes$manufacturer %in% c("MCDONNELL DOUGLAS AIRCRAFT CO", 
  "MCDONNELL DOUGLAS CORPORATION", "MCDONNELL DOUGLAS", "DOUGLAS")] <- "Douglas"
planes$manufacturer[planes$manufacturer == "AIRBUS INDUSTRIE"] <- "AIRBUS"
planes <- planes[!(planes$manufacturer %in% c("CANADAIR", "GULFSTREAM AEROSPACE")), ]
table(planes$manufacturer)

# Omit all N/As in planes (there are 70 in the year column)
planes <- na.omit(planes)
dim(planes)

# Combine the flights2_weather dataframe from last class with our updated planes data frame
# using the common tailnum  column
boom_boom <- merge(flights2_weather, planes)
str(boom_boom)

## Setting month, hour, weekday and route to our new merged dataframe
boom_boom$month<- substr(boom_boom$datetime,6, 7)
boom_boom$hour<- substr(boom_boom$datetime,12, 13)
boom_boom$weekday<- weekdays(as.Date(boom_boom$datetime))
boom_boom$route <- paste(boom_boom$origin, boom_boom$dest, sep = " - ")
str(boom_boom)

# Adding Planes------oh yeah!!!!
fm_boom_boom <- delay15 ~ month + hour + weekday + carrier + route + temp + dewp + humid +
  wind_dir + wind_speed + precip + visib + manufacturer + seats
mod_boom_boom <- glm(formula=fm_boom_boom, data=boom_boom, family="binomial")
pred_boom_boom <- predict(mod_boom_boom, newdata=boom_boom, type="response")
hist(pred_boom_boom)

# Confusion Matrix for our model
cut1 <- 0.2
conf1 <- table(pred_boom_boom > cut1, boom_boom$delay15 == 1)
conf1
tp1 <- conf1["TRUE","TRUE"]/sum(conf1[,"TRUE"])
tp1
fp1 <- conf1["TRUE","FALSE"]/sum(conf1[,"FALSE"])
fp1

# Checking decision tree model
library(rpart)
mod2 <- rpart(formula=fm_boom_boom, data=boom_boom, cp=0.001)
mod2
pred2 <- predict(mod2, newdata=boom_boom)
hist(pred2)
conf2 <- table(pred2 > cut1, boom_boom$delay15 == 1)
conf2
tp2 <- conf2["TRUE", "TRUE"]/sum(conf1[,"TRUE"])
tp2 
fp2 <- conf2["TRUE", "FALSE"]/sum(conf1[,"FALSE"])
fp2 
