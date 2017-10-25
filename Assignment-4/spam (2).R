## The spam filter (2) ##

# Reading data (customize) #
setwd("C:/Users/mcanela/Dropbox (Personal)/DATA-2017-2/[DATA-05] Decision Trees")
spam <- read.csv("spam.csv")
N <- nrow(spam)

# Binarization #
spam <- spam[, -(49:51)]
for(i in 1:48) spam[, i] <- as.numeric(spam[, i] > 0)

# Formula #
fm <- spam ~ .

# Logistic regression #
log_model <- glm(formula=fm, data=spam, family="binomial")
log_score <- predict(log_model, newdata=spam, type="response")
log_conf <- table(log_score > 0.5, spam$spam == 1)
log_conf
log_tp <- log_conf["TRUE", "TRUE"]/sum(log_conf[, "TRUE"])
log_tp
log_fp <- log_conf["TRUE", "FALSE"]/sum(log_conf[, "FALSE"])
log_fp

# Exploring scores #
par(mfrow=c(1,2))
hist(log_score[spam$spam == 1], breaks=20,
  main="Figure A. Scores (spam)", xlab="Predictive scores")
hist(log_score[spam$spam == 0], breaks=20,
  main="Figure B. Scores (legal)", xlab="Predictive scores")

# Picking training instances (50%) #
train <- sample(1:4601, size=N/2, replace=F)
spam1 <- spam[train, ]
spam2 <- spam[-train, ]

# Logistic regression (validation) #
log_model <- glm(formula=fm, data=spam1, family="binomial")

# Confusion matrix (training) #
log_score1 <- predict(log_model, newdata=spam1, type="response")
log_conf1 <- table(log_score1 > 0.5, spam1$spam == 1)
log_conf1
log_tp1 <- log_conf1["TRUE", "TRUE"]/sum(log_conf1[, "TRUE"])
log_tp1
log_fp1 <- log_conf1["TRUE", "FALSE"]/sum(log_conf1[, "FALSE"])
log_fp1

# Confusion matrix (test) #
log_score2 <- predict(log_model, newdata=spam2, type="response")
log_conf2 <- table(log_score2 > 0.5, spam2$spam == 1)
log_conf2
log_tp2 <- log_conf2["TRUE", "TRUE"]/sum(log_conf2[, "TRUE"])
log_tp2
log_fp2 <- log_conf2["TRUE", "FALSE"]/sum(log_conf2[, "FALSE"])
log_fp2

# Decision tree (validation) #
library(rpart)
tree_model <- rpart(formula=fm, data=spam1)

# Confusion matrix (training) #
tree_score1 <- predict(tree_model, newdata=spam1)
tree_conf1 <- table(tree_score1 > 0.5, spam1$spam == 1)
tree_conf1
tree_tp1 <- tree_conf1["TRUE", "TRUE"]/sum(tree_conf1[, "TRUE"])
tree_tp1
tree_fp1 <- tree_conf1["TRUE", "FALSE"]/sum(tree_conf1[, "FALSE"])
tree_fp1

# Confusion matrix (test) #
tree_score2 <- predict(tree_model, newdata=spam2)
tree_conf2 <- table(tree_score2 > 0.5, spam2$spam == 1)
tree_conf2
tree_tp2 <- tree_conf2["TRUE", "TRUE"]/sum(tree_conf2[, "TRUE"])
tree_tp2
tree_fp2 <- tree_conf2["TRUE", "FALSE"]/sum(tree_conf2[, "FALSE"])
tree_fp2
