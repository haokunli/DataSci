#### DATA SCIENCE- Team assignment - Washington Flight delay -
#### Team members: Yohei Kosaki, Joyce Lee, Carlo Bouroncle, Yun Gao

# Description of the current situation:
# a) 15 min delay usually causes customer to complain
# b) 15% of the flights delay more than 15 min
# c) Develop a model to predict the extent to which flights could be delay from Washington to NYC


### Code ###

# Read data
delay<-read.csv(file="https://raw.githubusercontent.com/cinnData/DATA/master/TeamProject-2/delays.csv")
#Check
str(delay)

### 0. Preparation of data###
# Develop Delay time
delay$sch_minutes <- as.numeric(ifelse(delay$schedtime>=1000,
  substr(delay$schedtime, 1, 2), substr(delay$schedtime, 1,1)))*60 + 
  as.numeric(ifelse(delay$schedtime>=1000, substr(delay$schedtime, 3, 4),
  substr(delay$schedtime, 2, 3)))
delay$dep_minutes <- as.numeric(ifelse(delay$deptime>=1000, substr(delay$deptime, 1, 2),
  substr(delay$deptime, 1, 1)))*60 + 
  as.numeric(ifelse(delay$deptime>=1000, substr(delay$deptime, 3, 4),
  substr(delay$deptime, 2, 3)))
delay$delayminutes <- ifelse(delay$dep_minutes-delay$sch_minutes<0, 0, 
  delay$dep_minutes-delay$sch_minutes)

# Develop Factor whether Delay or NOT
delay$delay0min <- ifelse(delay$delayminutes>0, 1, 0)

# Develop Factor whether 15mins Delay or NOT
delay$delay15min <- ifelse(delay$dep_minutes-delay$sch_minutes>=15, 1, 0)

# Check percentage of delay
mean(delay$delay0min)
mean(delay$delay15min)

# Develop departure hour
delay$departure_hour <- ifelse(delay$schedtime>=1000,substr(delay$schedtime, 1, 2),
  substr(delay$schedtime, 1, 1))
delay$departure_hour <- factor(delay$departure_hour)

# Develop combination of origin and destination
table(delay$origin, delay$dest)
# => we have 8 combinations
delay$combi <-factor(paste(delay$origin, delay$dest))

# Check
str(delay)

### 1. Linear regression ###
fm00 <- delay0min ~ carrier + combi + dayweek + daymonth + weather + departure_hour
fm01 <- delay15min ~ carrier + combi + dayweek + daymonth + weather + departure_hour
fm02 <- delayminutes ~ carrier + combi + dayweek + daymonth + weather + departure_hour

mod00 <- lm(formula=fm00, data=delay)
mod01 <- lm(formula=fm01, data=delay)
mod02 <- lm(formula=fm02, data=delay)

summary(mod00)$r.squared
summary(mod01)$r.squared
summary(mod02)$r.squared
## ---> R squared is too low, so it is difficult to predict by using linear regression


### 2. Logistic regression ###
## A. All delay ##
fm1 <- delay0min ~ carrier + combi + dayweek + daymonth + weather + departure_hour
cut0 <- mean(delay$delay0min)
mod1 <- glm(formula=fm1, data=delay, family="binomial")
summary(mod1)
pred1 <- predict (mod1, newdata=delay, type="response")
conf1 <- table (pred1> cut0, delay$delay0min==1); conf1
tp1 <- conf1["TRUE","TRUE"]/sum(conf1[,"TRUE"]); tp1
fp1 <- conf1["TRUE","FALSE"]/sum(conf1[,"FALSE"]); fp1

## B. Delay more than 15mins ##
fm2 <- delay15min ~ carrier + combi + dayweek + daymonth + weather + departure_hour
cut15 <- mean(delay$delay15min)
mod2 <- glm(formula=fm2, data=delay, family="binomial")
summary(mod2)
pred2 <- predict(mod2, newdata=delay, type="response")
conf2 <- table (pred2> cut15, delay$delay15min==1); conf2
tp2 <- conf2["TRUE","TRUE"]/sum(conf2[,"TRUE"]); tp2
fp2 <- conf2["TRUE","FALSE"]/sum(conf2[,"FALSE"]); fp2

##Visualize the results
par(mfrow=c(1,2))
barplot(tapply(delay$delay0min, delay$combi,mean), main="Average actual delay",
  xlab="Combination of origin and destination", cex.names=0.5)
barplot(tapply(pred1, delay$combi, mean), main="Average predicted delay",
  xlab="Combination of origin and destination", cex.names=0.5)

par(mfrow=c(1,2))
barplot(tapply(delay$delay15min, delay$combi, mean), main="Average actual delay",
  xlab="Combination of origin and destination", cex.names=0.5)
barplot(tapply(pred2, delay$combi, mean), main="Average predicted delay", xlab="Combination of origin and destination", cex.names=0.5)


## ---> The true positive percentage is very high and false positive percentage is also high. 
## ---> It is reasonable in flight industry as having delays are more expensive than having false alarms.
## ---> Therefore having a high false positive percentage can be allowed.


### 3. Decision Tree ###
# Make Sample
train <- sample(1:2201, size=1101, replace=F)

## A. All Delay ##
# Develop Decision Tree for all delay
fm1 <- delay0min ~ carrier + combi + dayweek + daymonth + weather + departure_hour
library(rpart)
tree1 <- rpart(formula=fm1, data=delay[train,])
tree1

# Plotting
par(mfrow=c(1,1))
plot(tree1, main="Figure 1. Decision tree for all delay")
text(tree1, font=1, cex=0.75)

# Confusion Matrix (Training)
pred_train1 <- predict(tree1, newdata=delay[train,])
conf_train1 <- table(pred_train1>cut0, delay[train,]$delay0min==1); conf_train1
tp_train1 <- conf_train1["TRUE","TRUE"]/sum(conf_train1[,"TRUE"]); tp_train1
fp_train1 <- conf_train1["TRUE","FALSE"]/sum(conf_train1[,"FALSE"]); fp_train1

#Confusion Matrix (Test)
pred_test1 <- predict(tree1, newdata=delay[-train,])
conf_test1 <- table(pred_test1>cut0, delay[-train,]$delay0min==1); conf_test1
tp_test1 <- conf_test1["TRUE","TRUE"]/sum(conf_test1[,"TRUE"]); tp_test1
fp_test1 <- conf_test1["TRUE","FALSE"]/sum(conf_test1[,"FALSE"]); fp_test1

## B. Delay more than 15mins ##
# Develop Decision Tree for delay more than 15mins
fm2 <- delay15min ~ carrier + combi + dayweek + daymonth + weather + departure_hour
library(rpart)
tree2 <- rpart(formula=fm2, data=delay[train,])
tree2

# Plotting
plot(tree2, main="Figure 2. Decision tree for delay more than 15mins")
text(tree2, font=1, cex=0.75)

# Confusion Matrix (Training)
pred_train2 <- predict(tree2, newdata=delay[train,])
conf_train2 <- table(pred_train2>cut15, delay[train,]$delay15min==1); conf_train2
tp_train2 <- conf_train2["TRUE","TRUE"]/sum(conf_train2[,"TRUE"]); tp_train2
fp_train2 <- conf_train2["TRUE","FALSE"]/sum(conf_train2[,"FALSE"]); fp_train2

# Confusion Matrix (Test)
pred_test2 <- predict(tree2, newdata=delay[-train,])
conf_test2 <- table(pred_test2>cut15, delay[-train,]$delay15min==1); conf_test2
tp_test2 <- conf_test2["TRUE","TRUE"]/sum(conf_test2[,"TRUE"]); tp_test2
fp_test2 <- conf_test2["TRUE","FALSE"]/sum(conf_test2[,"FALSE"]); fp_test2

## ---> The result of predicting all delays are slightly different from logistic regression. 
## ---> In addition, we saw the model tends to have an overfitting problem depending on taking the sample, probably because of the sample size. 
## ---> In this specific condition, we can conclude logistic regression is a more reliable predictive model, keeping everything else unchanged. 
