## The churn model ##

# Reading data (customize) #
churn <- read.csv("churn.csv", stringsAsFactors=F)
str(churn)
N <- nrow(churn)

# Formula #
fm <- churn ~ aclength + intplan + dataplan + ommin + omcall +
  otmin + otcall + ngmin + ngcall + imin + icall + cuscall

# Logistic regression #
mod <- glm(formula=fm, data=churn, family="binomial")
summary(mod)

# Inspecting datagb #
table(churn$dataplan, churn$datagb)

# Predictive scores #
score <- predict(mod, newdata=churn, type="response")

# Setting the cutoff #
cut1 <- 0.5

# Confusion matrix #
conf1 <- table(score > cut1, churn$churn==1)
conf1
tp1 <- conf1["TRUE", "TRUE"]/sum(conf1[,"TRUE"])
tp1
fp1 <- conf1["TRUE", "FALSE"]/sum(conf1[,"FALSE"])
fp1

# Histograms #
par(mfrow=c(1,2))
hist(pred1[churn$churn==1], breaks=20,
  main="Figure 2a. Scores (churners)", xlab="Churn score")
hist(pred1[churn$churn==0], breaks=20,
  main="Figure 2b. Scores (non-churners)", xlab="Churn score")

# Lower cutoff
cut2 <- mean(churn$churn)
conf2 <- table(pred1 > cut2, churn$churn == 1)
conf2
tp2 <- conf2["TRUE", "TRUE"]/sum(conf2[,"TRUE"])
tp2
fp2 <- conf2["TRUE", "FALSE"]/sum(conf2[,"FALSE"])
fp2
