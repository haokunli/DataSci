## The churn model (2) ##

# Reading data (customize) #
churn <- read.csv("https://raw.githubusercontent.com/cinnData/DATA/master/Data/churn.csv")
mean(churn$churn)

# Logistic regression #
fm <- churn ~ aclength + intplan + dataplan + ommin + omcall +
  otmin + otcall + ngmin + ngcall + imin + icall + cuscall
mod <- glm(formula=fm, data=churn, family="binomial")
score <- predict(mod, newdata=churn, type="response")

# Confusion matrices #
cut1 <- 0.5
conf1 <- table(score > cut1, churn$churn == 1)
cut2 <- mean(churn$churn)
conf2 <- table(score > cut2, churn$churn == 1)

# Benefit analysis #
B <- matrix(c(0, 0, -0.2, 0.8), nrow=2, byrow=TRUE)
benefit1 <- sum(conf1*B)
benefit1
benefit2 <- sum(conf2*B)
benefit2

# Benefit function #
f <- function(cutoff) {
  conf <- table(score > cutoff, churn$churn == 1)
  benefit <- sum(conf*B)
  return(benefit)
}

# Graphical solution #
cutoff <- seq(0.05, 0.95, by=0.01)
benefit <- f(cutoff[1])
for(i in 2:91) benefit <- c(benefit, f(cutoff[i]))
plot(cutoff, benefit, type="l")

# Alternative approach #
optimize(f=f, lower=0.05, upper=0.95, maximum=TRUE)
