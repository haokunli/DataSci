## The spam filter ##

# Setting work directory #
setwd("/Users/miguel/Dropbox/DATA-2017-2/[DATA-05] Decision trees")

# Loading data #
spam <- read.csv(file="spam.csv")
str(spam)

# Formula #
fm <- spam ~ .

# Setting the cutoff #
cut <- 0.5

# Decision tree #
library(rpart)
tree1 <- rpart(formula=fm, data=spam)
tree1

# Plotting #
plot(tree1, branch=0, main="Figure 1. Decision tree for spam filtering",
  margin=0.01)
text(tree1, font=1, cex=0.6)

# Confusion matrix (1) #
cut <- 0.5
score1 <- predict(tree1, newdata=spam)
conf1 <- table(score1 > cut, spam$spam==1)
conf1
tp1 <- conf1["TRUE", "TRUE"]/sum(conf1[,"TRUE"])
tp1
fp1 <- conf1["TRUE", "FALSE"]/sum(conf1[,"FALSE"])
fp1

# Exploring other cutoffs #
table(score1, spam$spam)

# Less pruning #
tree2 <- rpart(formula=fm, data=spam, cp=0.005)
tree2

# Confusion matrix (2) #
tree2 <- rpart(formula=fm, data=spam, cp=0.005)
score2 <- predict(tree2, newdata=spam)
conf2 <- table(score2 > 0.5, spam$spam==1)
conf2
tp2 <- conf2["TRUE", "TRUE"]/sum(conf2[,"TRUE"])
tp2
fp2 <- conf2["TRUE", "FALSE"]/sum(conf2[,"FALSE"])
fp2
