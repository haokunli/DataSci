## Assignment 1 (Tata Steel stock price) ##

# Opening file (customize) #
tata <- read.csv("F:/tata.csv", stringsAsFactors=F)
str(tata)

# Cleaning null values #
sum(tata$Open=="null")
tata <- tata[tata$Open != "null", ]
str(tata)
price <- as.numeric(tata$Adj.Close)
N <- nrow(tata)

# Summarizing adjusted price #
summary(price)

# Calculate returns and log returns #
return <- 100 * (price[-1]/price[-N] - 1)
logreturn <- 100 * (log(price[-1]) - log(price[-N]))
return[1:25]
logreturn[1:25]
summary(return - logreturn)

# Histogram of the returns #
hist(return, xlab="Daily returns", main="")
mean(abs(return - mean(return)) < 2*sd(return))

# Line plot #
plot(return, type="l", xlab="", ylab="Daily returns")
