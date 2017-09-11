## The churn model ##

# Setting work directory #
import os
os.chdir("/Users/miguel/Dropbox (IESE)/Data archive/DATA")

# Reading data #
import pandas as pd
churn = pd.read_csv("churn.csv")
churn.shape
churn.columns.values

# Logistic regression #
import statsmodels.api as sm
import statsmodels.formula.api as smf
fm = "churn ~ aclength + intplan + dataplan + datagb + ommin + omcall + \
  otmin + otcall + ngmin + ngcall + imin + icall + cuscall"
log_mod = smf.glm(formula=fm, data=churn, family=sm.families.Binomial()).fit()
log_mod.summary()
log_pred = log_mod.predict()

# Plotting predictive scores #
import matplotlib.pyplot as plt
plt.hist(log_pred, 25, color=0.9)
plt.title("Scores histogram")
plt.xlabel("Score")
plt.ylabel("Frequency")
plt.show()

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


