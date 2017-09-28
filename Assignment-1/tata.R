## Assignment 1 (Tata Steel stock price) ##

# Setting working directory #
wd1 <- "C:/Users/mcanela/Dropbox (Personal)/DATA-2017-2"
wd2 <- "/Buro/Assignment 1"
wd <- paste(url1, url2, sep="")
setwd(wd)

# Opening file (local) #
tata <- read.csv(file="TATASTEEL.NS.csv", stringsAsFactors=F)
str(tata)

# Opening file (remote) #
url1 <- "https://raw.githubusercontent.com/cinnData/DATA/master/"
url2 <- "Assignment-1/TATASTEEL.NS.csv"
url <- paste(url1, url2, sep="")
tata <- read.csv(url, stringsAsFactors=F)

# Cleaning null values #
sum(tata$Open=="null")
tata <- tata[tata$Open != "null", ]
str(tata)
price <- as.numeric(tata$Adj.Close)
N <- nrow(tata)

# Summarizing adjusted price #
summary(price)

# Calculate returns and log returns #
return <- 100 * (price[2:N]/price[1:(N-1)] - 1)
logreturn <- 100 * (log(price[2:N]) - log(price[1:(N-1)]))
return[1:25]
logreturn[1:25]
summary(return - logreturn)

# Histogram of the returns #
hist(return, xlab="Daily returns", main="")
mean(abs(return - mean(return)) < 2*sd(return))

# Line plot #
plot(return, type="l", xlab="", ylab="Daily returns")
