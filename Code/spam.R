## [DATA-04] Example: The spam filter ##
# Setting work directory
setwd("/Users/miguel/Dropbox/Current jobs/DATA-2016-2/DATA-04")

# Loading data
spam <- read.csv(file="spam.csv")
str(spam)

# Picking training instances (50%)
train <- sample(1:4601, size=2301, replace=F)

# Formula
fm1 <- spam ~ .

# Setting the cutoff
cut <- 0.5

# Decision tree
library(rpart)
tree1 <- rpart(formula=fm1, data=spam[train,])
help(rpart.object)
tree1

# Plotting
plot(tree1, branch=0, main="Figure 1. Decision tree for spam filtering")
text(tree1, font=1, cex=0.75)

# Confusion matrix (training)
pred_train1 <- predict(tree1, newdata=spam[train,])
conf_train1 <- table(pred_train1 > cut, spam[train,]$spam==1); conf_train1
tp_train1 <- conf_train1["TRUE", "TRUE"]/sum(conf_train1[,"TRUE"]); tp_train1
fp_train1 <- conf_train1["TRUE", "FALSE"]/sum(conf_train1[,"FALSE"]); fp_train1

# Confusion matrix (test)
pred_test1 <- predict(tree1, newdata=spam[-train,])
conf_test1 <- table(pred_test1 > cut, spam[-train,]$spam==1); conf_test1
tp_test1 <- conf_test1["TRUE", "TRUE"]/sum(conf_test1[,"TRUE"]); tp_test1
fp_test1 <- conf_test1["TRUE", "FALSE"]/sum(conf_test1[,"FALSE"]); fp_test1

# Exploring other cutoffs
table(pred_train1, spam$spam[train])

# Less pruning
tree2 <- rpart(formula=fm1, data=spam[train,], cp=0.005)
tree2

# Confusion matrix (training)
pred_train2 <- predict(tree2, newdata=spam[train,])
conf_train2 <- table(pred_train2 > cut, spam[train,]$spam==1); conf_train2
tp_train2 <- conf_train2["TRUE", "TRUE"]/sum(conf_train2[,"TRUE"]); tp_train2
fp_train2 <- conf_train2["TRUE", "FALSE"]/sum(conf_train2[,"FALSE"]); fp_train2

# Confusion matrix (test)
pred_test2 <- predict(tree2, newdata=spam[-train,])
conf_test2 <- table(pred_test2 > cut, spam[-train,]$spam==1); conf_test2
tp_test2 <- conf_test2["TRUE", "TRUE"]/sum(conf_test2[,"TRUE"]); tp_test2
fp_test2 <- conf_test2["TRUE", "FALSE"]/sum(conf_test2[,"FALSE"]); fp_test2
