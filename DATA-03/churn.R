## [DATA-03] Example: The churn model ##
setwd("/Users/miguel/Dropbox/Current jobs/DATA-2016-2/DATA-03")

# Reading data
churn <- read.csv("churn.csv")
str(churn)

# Logistic regression
fm1 <- churn ~ aclength + intplan + dataplan + datagb + ommin + omcall + otmin + otcall + ngmin +
  ngcall + imin + icall + cuscall
mod1 <- glm(fm1, data=churn, family="binomial") 
summary(mod1)
pred1 <- predict(mod1, newdata=churn, type="response")

# Plotting predictive scores
hist(pred1, main="Figure 2. Predictive scores for churn", xlab="Predictive scores")
	
# Setting the cutoff
cut1 <- 0.5

# Confusion matrix
conf1 <- table(pred1 > cut1, churn$churn==1); conf1
tp1 <- conf1["TRUE", "TRUE"]/sum(conf1[,"TRUE"]); tp1
fp1 <- conf1["TRUE", "FALSE"]/sum(conf1[,"FALSE"]); fp1

# Splitting the histogram
par(mfrow=c(1,2))
hist(pred1[churn$churn==1], breaks=20, main="Figure 3a. Predictive scores (churners)",
  xlab="Predictive scores")
hist(pred1[churn$churn==0], breaks=20, main="Figure 3b. Predictive scores (non-churners)",
  xlab="Predictive scores")

# Lower cutoff
cut2 <- mean(churn$churn)
conf2 <- table(pred1 > cut2, churn$churn==1); conf2
tp2 <- conf2["TRUE", "TRUE"]/sum(conf2[,"TRUE"]); tp2
fp2 <- conf2["TRUE", "FALSE"]/sum(conf2[,"FALSE"]); fp2

# Benefit analysis
B <- matrix(c(0, 0, -0.2, 0.8), nrow=2, byrow=TRUE)
benefit1 <- sum(conf1*B); benefit1
benefit2 <- sum(conf2*B); benefit2

# Optimal cutoff
f_benefit <- function(cutoff) {
	conf <- table(pred1 > cutoff, churn$churn==1)
	benefit <- sum(conf*B)
	return(benefit)
	}
optimize(f=f_benefit, lower=0.05, upper=0.95, maximum=TRUE)

# Benefit as a function of the cutoff
cutoff <- seq(0.05, 0.95, by=0.01)
benefit[1] <- f_benefit(cutoff[1]); for(i in 2:91) benefit <- c(benefit, f_benefit(cutoff[i]))
plot(cutoff, benefit, type="l")


