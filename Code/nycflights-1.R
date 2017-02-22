## Read Data

airline <- read.csv("E:/airlines.csv", stringsAsFactors=T)
airport <- read.csv("E:/airports.csv", stringsAsFactors=T)
flight <- read.csv("E:/flights.csv", stringsAsFactors=T)
plane <- read.csv("E:/planes.csv", stringsAsFactors=T)
weather <- read.csv("E:/weather.csv", stringsAsFactors=T)

######## Plane

# size check
dim(plane)

# variables check
str(plane)

# number of NA -year and speed have NA
summary(plane)

## Plot plane speed and the year: it was manufactured after 1983 no speed has been measured => speed should be omitted from 
plot(plane$year,plane$speed)
table(plane$year, is.na(plane$speed))


######## Weather

# size check
dim(weather)

# variables check
str(weather)

# number of NA -temp, dewp, humid, wind_speed, wind_gust, wind_dir, and  pressure have NA
summary(weather)

# thermometer broken -cannot measure temperature, dew point and humidity at the same time => data could be missing by accident
weather[is.na(weather$temp)==TRUE,]
weather[is.na(weather$dewp)==TRUE,]
weather[is.na(weather$humid)==TRUE,]

# wind@wind_speed is same as wind_gust; perfect correlation => one of these variables should be omitted
weather[is.na(weather$wind_speed)==TRUE,]
weather[is.na(weather$wind_gust)==TRUE,]
weather_wind <- weather[is.na(weather$wind_gust)==FALSE,]
cor(weather_wind$wind_gust, weather_wind$wind_speed)
weather_wind <- weather[is.na(weather$wind_gust)==FALSE&weather$wind_speed>0,]
max(weather_wind$wind_gust/weather_wind$wind_speed)
min(weather_wind$wind_gust/weather_wind$wind_speed)

# wind speed comparison between all the values measured and the values when direction was not measured =>low wind speed could result in failure of measuring direction: natural
mean(weather_wind$wind_speed)
weather_wind_dir <- weather[is.na(weather$wind_dir)==TRUE,]
weather_wind_dir <- weather[is.na(weather$wind_dir)==TRUE&is.na(weather$wind_speed)==FALSE,]
mean(weather_wind_dir$wind_speed)

par(mfrow=c(1,2))
hist(weather_wind_dir$wind_speed, breaks=seq(0,10000,1), main="", xlab="wind speed when wind rirection is not measured", xlim=c(0,10))
hist(weather_wind$wind_speed, breaks=seq(0,10000,1), main="", xlab="wind speed for all", xlim=c(0,10))

# Higher visibility might make the possibility of occurrence of NA at the pressure lower. : natural phenomenon?
 tapply(is.na(weather$pressure), weather$visib, mean).


######## Flight

# size check
dim(flight)

# variables check
str(flight)

# number of NA ->dep_time, dep_delay, arr_time, arr_delay, tailnum, and air_time have NA
summary(flight)

# NA of dep_time and dep_delay match: when dep_time is missing, dep_delay is also missing :make sense
sum(is.na(flight$dep_time)==TRUE&is.na(flight$dep_delay)==TRUE)

# when arr_time is missing, arr_delay is also missing
sum(is.na(flight$arr_time)==TRUE&is.na(flight$arr_delay)==TRUE)

# in some cases, however, arr_time is available but arr_delay is missing : need investigation
# calculate time difference between arr_time and sched_arr_time in MINUTE
flight_pure <- flight[is.na(flight$arr_time)==FALSE&is.na(flight$arr_delay)==TRUE,]
arr_hh<-floor(flight_pure$arr_time/100)
arr_mm <-flight_pure$arr_time-arr_hh*100
schedule_arr_hh <-floor(flight_pure$sched_arr_time/100)
schedule_arr_mm <- flight_pure$sched_arr_time-schedule_arr_hh*100
diff <- (arr_hh*60+arr_mm)-(schedule_arr_hh*60+schedule_arr_mm)
diff_pos <- diff[diff>=0]
diff_neg <- diff[diff<0]
diff_neg = diff_neg+24*60
df1 <- data.frame(diff_pos)
df2 <- data.frame(diff_neg)
names(df1) <-"n"
names(df2) <-"n"
df3 <- rbind(df1, df2)
par(mfrow=c(1,1))
hist(df3$n)
mean(df3$n)
max(df3$n)
min(df3$n)
## A lot of flight delays were not measured by accident...or on purpose. arr_delay should be omitted



# when arr_delay is missing, tailnum is not necessarily missing
sum(is.na(flight$tailnum)==TRUE)
sum(is.na(flight$tailnum)==TRUE&is.na(flight$arr_delay)==TRUE)
sum(is.na(flight$tailnum)==FALSE&is.na(flight$arr_delay)==TRUE)


# NA of air_time and arr_delay match: when air_time is missing, arr_delay is also missing
sum(is.na(flight$air_time)==TRUE)
sum(is.na(flight$arr_delay)==TRUE&is.na(flight$air_time)==TRUE)

# Examine missing arr_delay and carrier/dest
tapply(is.na(flight$arr_delay), flight$carrier, mean)
tapply(is.na(flight$arr_delay), flight$dest, mean)