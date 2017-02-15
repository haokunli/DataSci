# Reading data
deposit <- read.csv("E:/deposit.csv",stringsAsFactors=F)
str(deposit)

# Splitting training data (50%)
train <- sample(1:45211, size=22605, replace=F)

# Setting the formula
deposit$deposit <- as.numeric(deposit$deposit=="yes")
fm1 <- deposit ~ .

# Setting the cutoff, baseline of 50%
cut <- 0.5

# Decision Tree (1st attempt)
library(rpart)
tree1 <- rpart(formula=fm1, data=deposit[train,])
tree1
# The tree appears too small given the size of the data set

# Confusion matrix 1 (training)
pred_train1 <- predict(tree1, newdata=deposit[train,])
conf_train1 <- table(pred_train1 > cut, deposit[train,]$deposit==1)
conf_train1
tp_train1 <- conf_train1["TRUE", "TRUE"]/sum(conf_train1[,"TRUE"])
tp_train1
fp_train1 <- conf_train1["TRUE", "FALSE"]/sum(conf_train1[,"FALSE"])
fp_train1
# TP very low

# Two Options Now: 1) alter tree complexity or 2) alter cutoff
# Begin with altering the tree complexity

# Decision Tree (2nd attempt): set tree complexity = 0.002 (from 0.01 default)
tree2 <- rpart(formula=fm1, data=deposit[train,], cp=0.002)
tree2
# The tree appears larger, more appropriate

# Confusion matrix 2 (training)
pred_train2 <- predict(tree2, newdata=deposit[train,])
conf_train2 <- table(pred_train2 > cut, deposit[train,]$deposit==1); conf_train2
tp_train2 <- conf_train2["TRUE", "TRUE"]/sum(conf_train2[,"TRUE"]); tp_train2
fp_train2 <- conf_train2["TRUE", "FALSE"]/sum(conf_train2[,"FALSE"]); fp_train2
# TP still very low
# Alter cutoff
hist(pred_train1)
# See most data is below 0.05

# Decision Tree (3rd attempt): new cutoff of 0.05 (down from 0.5)
cut <- 0.05
tree3 <- rpart(formula=fm1, data=deposit[train,], cp=0.002)
tree3

# Confusion matrix 3 (training)
pred_train3 <- predict(tree3, newdata=deposit[train,])
conf_train3 <- table(pred_train3 > cut, deposit[train,]$deposit==1); conf_train3
tp_train3 <- conf_train3["TRUE", "TRUE"]/sum(conf_train3[,"TRUE"]); tp_train3
fp_train3 <- conf_train3["TRUE", "FALSE"]/sum(conf_train3[,"FALSE"]); fp_train3
# TP improved a lot

# Confusion matrix3 (test)
pred_test3 <- predict(tree3, newdata=deposit[-train,])
conf_test3 <- table(pred_test3 > cut, deposit[-train,]$deposit==1); conf_test3
tp_test3 <- conf_test3["TRUE", "TRUE"]/sum(conf_test3[,"TRUE"]); tp_test3
fp_test3 <- conf_test3["TRUE", "FALSE"]/sum(conf_test3[,"FALSE"]); fp_test3
# close match to train so no overfitting
