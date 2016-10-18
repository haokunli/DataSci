## Direct Marketing of Term Deposits ##

## Team Project 3 - Direct Marketing of Term Deposits ##
## Team Members: Tulio Henrique, Gunel Mehdiyeva, Santhosh Donkada, Pranav Ghei

## Current Situation
## 1. Objective is to find a predictive model based on data of the preceding campaign
## 2. Which shows if the client subscribes the deposit
## 3. Current success rate of marketing campaign is 11.7% (5289 success rate out of 45211)
## 4. The model should allow to reduce the number of calls in a relevant way without loosing a relevant number of subscribers

# Setting work directory (customize)
setwd("E:/Biz/Semester3/MBA-BCN-2017-T4-DATA/DATA-master/TeamProject-3")

# Reading data
deposit <- read.csv(file="deposit.csv")

str(deposit)
head(deposit)
summary(deposit)

#Combining some variables in column job

deposit$job <- as.factor(gsub("housemaid", "services", deposit$job))
deposit$job <- as.factor(gsub("admin", "services", deposit$job))
deposit$job <- as.factor(gsub("technician", "blue-collar", deposit$job))

str(deposit)

# Data Cleaning

deposit$deposit <- as.numeric(deposit$deposit=="yes")
table(deposit$deposit)

deposit$housing <- as.numeric(deposit$housing=="yes")
table(deposit$housing)

deposit$default <- as.numeric(deposit$default=="yes")
table(deposit$default)

deposit$loan <- as.numeric(deposit$loan=="yes")
table(deposit$loan)

deposit$pdays <- as.numeric(gsub("-1", "0", deposit$pdays))

str(deposit)

# Training Instance
train <- sample(1:45211, size=22605, replace=F)

# Formula Setting
fm <- deposit ~ .

# Logistic Regression
mod1 <- glm(formula=fm, data=deposit[train,], family="binomial")
pred1 <- predict(mod1, newdata=deposit[-train,], type="response")

# Decision Tree
library(rpart)
mod2 <- rpart(formula=fm, data=deposit[train,], cp=0.001)
pred2 <- predict(mod2, newdata=deposit[-train,])

#Confusion Matrix

eval <- function(pred, cut) {conf <- table(pred>cut, deposit[-train,]$deposit==1)
tp <- conf["TRUE", "TRUE"]/sum(conf[,"TRUE"])
fp <- conf["TRUE", "FALSE"]/sum(conf[,"FALSE"])
return(c(tp, fp))
}

#for cutoff 0.5 and 0.1

matrix(c(eval(pred1, 0.5), eval(pred1, 0.1), eval(pred2, 0.5), eval(pred2, 0.1)),
nrow=2, byrow=T,
dimnames = list(c("Logistic", "Tree"), c("cutoff 0.5", "", "cutoff 0.1", "")))





