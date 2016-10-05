setwd("C:/Team Latam")
data<-read.csv("bike.csv", stringsAsFactors=FALSE)
str(data)

#Converting date string into different fields) and extracting only casual data#

year<-as.numeric(substr(data$datetime,1,4))
month<-as.numeric(substr(data$datetime,6,7))
day<-as.numeric(substr(data$datetime,9,10))
hour<-as.numeric(substr(data$datetime,12,13))

#Now were going to explore the effect of different variables#

#Effect of month over casual with barchart plot#

tapply(data$casual,month,mean)
cor(data$casual,month)
Chart_Casual_Month <- tapply(data$casual,month,mean)
barplot(Chart_Casual_Month, main="Casual Users - Avg Users per Month",xlab="Month of the Year")

#Effect of hour over casual with barchart plot#

tapply(data$casual,hour,mean)
cor(data$casual,hour)
Chart_Casual_Hour <- tapply(data$casual,hour,mean)
barplot(Chart_Casual_Hour, main="Casual Users - Avg Users Throughtout the Day",xlab="Hour of the day")

#Effect of season over casual with barplot chart#

tapply(data$casual,data$season,mean)
cor(data$casual,data$season)
Chart_Casual_season <- tapply(data$casual,data$season,mean)
barplot(Chart_Casual_season, main="Casual Users - Avg Users Throughtout the Seasons",xlab="Season of the year")

#Effect of working day and holiday

table(data$workingday,data$holiday)

#They're not MECE!!#

#Effect of weather conditions#

table(data$weather)
tapply(data$casual,data$weather,mean)
Chart_Casual_weather <- tapply(data$casual,data$weather,mean)
barplot(Chart_Casual_weather, main="Casual Users - Avg Users Depending on the Weather",xlab="Current Weather")


#Type of weather seems to affect the use of bikes, we also have to disregard the observation when weather=4#

#Other numerical weather variables alfo inffluenc but we must avoid colinearity#

cor(data.frame(data$casual,data$temp,data$atemp,data$humidity,data$windspeed))

#Writing the model#

fm1<-data$casual~factor(data$season) + factor(data$workingday) + factor(data$holiday) + factor(data$weather) + data$temp + data$humidity + data$windspeed
#Results of the regression#

model<-lm(fm1)
summary(model)

##We can play here with other types of models##

#Selecting subset without weather=4 and creating new model#
newdata <- subset(data, weather<4)
fm2 <- newdata$casual~factor(newdata$season) + factor(newdata$workingday) + factor(newdata$holiday) + factor(newdata$weather) + newdata$temp + newdata$humidity + newdata$windspeed
model2<-lm(fm2)
summary(model2)

#Determining if replacing temp by atemp improves the model#
fm3 <- newdata$casual~factor(newdata$season) + factor(newdata$workingday) + factor(newdata$holiday) + factor(newdata$weather) + newdata$atemp + newdata$humidity + newdata$windspeed
model3<-lm(fm3)
summary(model3)

#Determining whether or not windspeed adds relevant information#
fm4 <- newdata$casual~factor(newdata$season) + factor(newdata$workingday) + factor(newdata$holiday) + factor(newdata$weather) + newdata$temp + newdata$humidity
model4<-lm(fm4)
summary(model4)

#Determining whether or not humidity adds relevant information#
fm5 <- newdata$casual~factor(newdata$season) + factor(newdata$workingday) + factor(newdata$holiday) + factor(newdata$weather) + newdata$temp
model5<-lm(fm5)
summary(model5)


