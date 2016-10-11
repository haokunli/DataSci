# Setting Work Directory
setwd("/Users/Brian/Documents/IESE MBA/Term 4/DATA")

# Loading data & Summary of data
delay <- read.csv(file="delay.csv")
summary(delay)
str(delay)

# Create Critieria for Delaying
delaying <- delay$deptime - delay$schedtime
str(delaying)

# Change the Format of Departure Time
as.Date(delay$date)
as.double(as.Date(delay$date))
datenew <- as.double(as.Date(delay$date))

# Clear Flight Number and Tailnummber
delay0 <- data.frame(delay,datenew)
delay1 <- data.frame(delay0[,-8])
delay2 <- data.frame(delay1[,-10])
delay3 <- data.frame(delay2[,-1])
str(delay3)

# Add Delaying Criteria to Original File
delayfinal <- data.frame(delay3,delaying)
str(delayfinal)

# Add Dummy
delaydummy <- numeric(length(delayfinal$delaying))
delaydummy [delayfinal$delaying>15] <- 1
delaydummy [delayfinal$delaying<15] <-0
delaydummy

# Add Dummy to the Data
delaydummydf <- data.frame(delayfinal,delaydummy)
str(delaydummydf)

# Training Instance
train <- sample(1:2201, size=1101, replace=F)

# Formula and Preliminary Cutoff Setting
fm1 <- delaydummy ~ schedtime + deptime + carrier + origin + dest + distance + dayweek +daymonth + weather + datenew 
cut <- 0.5

# Decision Tree
library(rpart)
tree1 <- rpart(formula=fm1, data=delaydummydf[train,])
help(rpart.object)

# Plotting the Model
plot(tree1, main="Figure 1. Decision Tree")
text(tree1, font=1, cex=0.8)

# Optizmizing the Chart
plot(tree1, branch=0, main="Figure 2. Alternative Layout", margin=0.05)
text(tree1, font=1, cex=0.6)

# Confusion Matrix (Training)
cut <- 0.5
pred_train1 <- predict(tree1, newdata=delaydummydf[train,])
conf_train1 <- table(pred_train1 > cut, delaydummydf[train,]$delaydummy==1); conf_train1
tp_train1 <- conf_train1["TRUE", "TRUE"]/sum(conf_train1[,"TRUE"]); tp_train1
fp_train1 <- conf_train1["TRUE", "FALSE"]/sum(conf_train1[,"FALSE"]); fp_train1

# Confusion Matrix (Test)
cut <- 0.5
pred_test1 <- predict(tree1, newdata=delaydummydf[-train,])
conf_test1 <- table(pred_test1 > cut, delayfinal[-train,]$delaydummy==1); conf_test1
tp_test1 <- conf_test1["TRUE", "TRUE"]/sum(conf_test1[,"TRUE"]); tp_test1
fp_test1 <- conf_test1["TRUE", "FALSE"]/sum(conf_test1[,"FALSE"]); fp_test1

# Histogram (Test)
hist(pred1_test1, main="", xlab="Delay Scores")

# Other Cutoffs
table(pred_train1, delaydummydf$delaydummy[train])

# Less Pruning
tree2 <- rpart(formula=fm1, data=delaydummydf[train,], cp=0.002)

# Plotting the Model
plot(tree2, main="Figure 1. Decision Tree")
text(tree2, font=1, cex=0.8)

# Optizmizing the Chart
plot(tree2, branch=0, main="Figure 2. Alternative Layout", margin=0.05)
text(tree2, font=1, cex=0.6)

# Confusion Matrix (Training_New Purning)
cut <- 0.5
pred_train2 <- predict(tree2, newdata=delaydummydf[train,])
conf_train2 <- table(pred_train2 > cut, delaydummydf[train,]$delaydummy==1); conf_train2
tp_train2 <- conf_train2["TRUE", "TRUE"]/sum(conf_train2[,"TRUE"]); tp_train2
fp_train2 <- conf_train2["TRUE", "FALSE"]/sum(conf_train2[,"FALSE"]); fp_train2

# Confusion Matrix (Test_New Purning))
cut <- 0.5
pred_test2 <- predict(tree2, newdata=delaydummydf[-train,])
conf_test2 <- table(pred_test2 > cut, delayfinal[-train,]$delaydummy==1); conf_test2
tp_test2 <- conf_test2["TRUE", "TRUE"]/sum(conf_test2[,"TRUE"]); tp_test2
fp_test2 <- conf_test2["TRUE", "FALSE"]/sum(conf_test2[,"FALSE"]); fp_test2


