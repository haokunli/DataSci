#Read data set
flight <- read.csv("E:/flights.csv", stringsAsFactors=F)
str(flight)


## Step 1: examining and cleaning the NAs, mostly done by Team 1 ##
summary(flight)
flight <- na.omit(flight)


## Step 2: Define departure delay and create new columns ## 
flight$delay00 <- as.numeric(flight$dep_delay>0)
flight$delay05 <- as.numeric(flight$dep_delay>5)
flight$delay10 <- as.numeric(flight$dep_delay>10)
flight$delay15 <- as.numeric(flight$dep_delay>15)


## Step 3: Extract Month, Hour and create new columes ##
  
# Month #
flight$Month <- substr(flight$datetime,6,7)
table(flight$Month)

# Hour #
flight$Hour <- substr(flight$datetime,12,13)
table(flight$Hour)

# Workdays/Weekends #
# There are 2 formats of time in R: 1)date yyyy-mm-dd
# 2) datetime: yyyy-mm-dd hh:mm:ss 
# To use the as.POSIXlt() function, need to create a new colume with date format
flight$date <- substr(flight$datetime,1,10)
# Create a new colume "weekday" to indicate which date the day is. 
# Function as.POSIXlt()$wday will serve the purpose: Sunday = 0, Monday = 1, Tuesday = 2, etc #
flight$Weekday <- as.POSIXlt(flight$date)$wday
table(flight$Weekday)
# Change the "week" value from number to "Sun", "Mon", etc. #
flight$Weakday <- factor(flight$Weekday, levels= 0:6,
	labels = c("Sun","Mon","Tue","Wed","Thu","Fri","Sat"))
table(flight$Weakday)


## Step 4. Evaluate delay by frequency (% of delays) and severity (average delay in minutes) ##

# A. Group by month #

# Frequency #
plot(tapply(flight$delay00, flight$Month, mean), type = "l",
	xlab = 'Month', ylab = '% of delayed flights')
axis(1,1:12)
title(main = "Frequency - 0 min")

plot(tapply(flight$delay05,flight$Month,mean), type = "l",
	xlab = 'Month', ylab = '% of delayed flights')
axis(1,1:12)
title(main = "Frequency - 5 min")

plot(tapply(flight$delay10, flight$Month, mean), type = "l",
	xlab = 'Month', ylab = '% of delayed flights')
axis(1,1:12)
title(main = "Frequency - 10 min")

plot(tapply(flight$delay15, flight$Month,mean), type = "l",
	xlab = 'Month', ylab = '% of delayed flights')
axis(1,1:12)
title(main = "Frequency - 15 min")

# Severity #
tapply(flight$dep_delay, flight$Month, mean)
plot(tapply(flight$dep_delay, flight$Month, mean), type = "l",
	xlab = 'Month', ylab = 'Average Delay in minutes')
axis(1,1:12)
title(main = "Severity (Avg. Delay in Minutes)")


# B. Group by hour #

# Frequency #
barplot(tapply(flight$delay00, flight$Hour, mean), xlab = 'Hour', 
	ylab = '% of delayed flights')
title(main = "Frequency - 0 min")
barplot(tapply(flight$delay05, flight$Hour, mean), xlab = 'Hour',
	ylab = '% of delayed flights')
title(main = "Frequency - 5 min")
barplot(tapply(flight$delay10, flight$Hour, mean), xlab = 'Hour',
	ylab = '% of delayed flights')
title(main = "Frequency - 10 min")
barplot(tapply(flight$delay15, flight$Hour, mean), xlab = 'Hour',
	ylab = '% of delayed flights')
title(main = "Frequency - 15 min")

# Severity #
tapply(flight$dep_delay, flight$Hour, mean)
barplot(tapply(flight$dep_delay, flight$Hour, mean),
	xlab = 'Hour',ylab = 'Average Dealy in minutes')
title(main = "Severity(Avg. Delay in Minutes)")


# C. Group by weekdays #

# Frequency #

barplot(tapply(flight$delay00,flight$Weakday,mean),xlab = 'date',ylab = '% of delayed flights')
title(main = "Frequency - 0 min")
barplot(tapply(flight$delay05,flight$Weakday,mean),xlab = 'date',ylab = '% of delayed flights')
title(main = "Frequency - 5 min")
barplot(tapply(flight$delay10,flight$Weakday,mean),xlab = 'date',ylab = '% of delayed flights')
title(main = "Frequency - 10 min")
barplot(tapply(flight$delay15,flight$Weakday,mean),xlab = 'date',ylab = '% of delayed flights')
title(main = "Frequency - 15 min")

# Severity #
barplot(tapply(flight$dep_delay, flight$Weakday, mean), 
	xlab = 'date', ylab = 'Average Dealy in minutes')
title(main = "Severity(Avg. Delay in Minutes)")


## Step 5. Linear Regression ##
fm0 <- dep_delay ~ Month + Hour + Weakday
mod0 <- lm(formula = fm0, data = flight)
summary(mod0)

# Reasons for low R-squared 0.0614 #
# The skewed distribution, especially the very right end cause huge error in prediction #
# We cannot log the dep_delay because of negative value #
# Furthermore, for airport management team, it might not be necessary to accurately 
# predict how many minutes the flight is delayed; 
# alternatively, whether a flight is delayed or not is good enough for daily management #
hist(flight$dep_delay)


## Step 6. Logistic Regression ##

## Model A. Only include Month, Hour, Week #
# See their impact on predicting delay in 0min and 15 min #

## a. delay in 0 min with Model A.#
fm1 <- delay00 ~ Month + Hour + Weakday
mod1 <- glm(formula = fm1, data = flight, family = "binomial" )
summary(mod1)
# prediction 
pred1 <- predict(mod1, newdata = flight, type = "response")
hist(pred1, main="Figure 1. Predictive scores for delay in 0min Model A.", 
	xlab = "Predictive scores")
cut <- 0.5
conf1 <- table(pred1 > cut, flight$delay00==1)
conf1
# confusion matrix
pred1_quality <- (conf1["TRUE","TRUE"] + conf1["FALSE","FALSE"])/sum(conf1)
pred1_quality
## 0.6492305


## b. delay in 15 min with Model A.#
fm2 <- delay15 ~ Month + Hour + Weakday
mod2 <- glm(formula = fm2, data = flight, family = "binomial" )
# prediction 
pred2 <- predict(mod2, newdata = flight, type = "response")
hist(pred2, main="Figure 2. Predictive scores for delay in 15 min with Model A.",
	xlab = "Predictive scores")
cut <- 0.5
conf2 <- table(pred2 > cut, flight$delay15==1)
conf2
# confusion matrix
pred2_quality <- (conf2["TRUE","TRUE"] + conf2["FALSE","FALSE"])/sum(conf2)
pred2_quality
## 0.785661


## MoDel B. Add origin and carriers to the model ##
# See their impact on predicting delay in 0min and 15 min #

## c. delay in 0 min with Model B.#
fm3 <- delay00 ~ Month + Hour + Weakday + origin + carrier
mod3 <- glm(formula = fm3, data = flight, family = "binomial" )
summary(mod3)
#Prediction 
pred3 <- predict(mod3, newdata = flight, type = "response")
hist(pred3, main="Figure 3. Predictive scores for delay in 00 min with Model B.",
	xlab = "Predictive scores")
cut <- 0.5
conf3 <- table(pred3 > cut, flight$delay00==1);conf3
pred3_quality <- (conf3["TRUE","TRUE"] + conf3["FALSE","FALSE"])/sum(conf3)
pred3_quality
## 0.6654488

## d. delay in 15 min with Model B.#
fm4 <- delay15 ~ Month + Hour + Weakday + origin + carrier
mod4 <- glm(formula = fm4, data = flight, family = "binomial" )
# prediction 
pred4 <- predict(mod4, newdata = flight, type = "response")
hist(pred4, main="Figure 2. Predictive scores for delay in 15 min Model B.",
	xlab = "Predictive scores")
cut <- 0.5
conf4 <- table(pred4 > cut, flight$delay15==1)
conf4
# confusion matrix
pred4_quality <- (conf4["TRUE","TRUE"] + conf4["FALSE","FALSE"])/sum(conf4)
pred4_quality
## 0.7883402

## Conclusion: logistic regression works better than linear regression##
## It's more accurate to use delay in 15 minutes as a cutoff to predict delay ##
