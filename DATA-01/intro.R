## [DATA-01] Data science with R ##

# Start
2 + 2

# Numeric vector
x <- 1:10
x

# Character vector
y <- c("Messi", "Neymar", "Cristiano")
y

# Logical vector
z <- x > 5
z

# Matrix
A <- matrix(1:24, nrow=4)
A
A[2,3]

# Data frame
df <- data.frame(v1=1:10, v2=10:1, v3=rep(-1,10))
df
df$v1

# Subsetting
x[1:3]
x[x>=5]
A[1:2, 3:6]
df[, -3]
df[df$v1<df$v2, ]

# Function
f <- function(x) 1/(1+x^2)
f(1)

# Importing data to R
url1 <- "http://real-chart.finance.yahoo.com/table.csv"
url2 <- "?s=ICICIBANK.NS&a=00&b=01&c=2003&d=11&e=31&f=2015"
url <- paste(url1, url2, sep="")
icici <- read.csv(url, stringsAsFactors=F)

# Checks
str(icici)
dim(icici)
head(icici)
tail(icici)

# Summary
summary(icici)

# Returns exploratory analysis of returns
return <- icici$Adj.Close[-1]/icici$Adj.Close[-3304] - 1
hist(return, main="ICICI Bank Ltd. Adjusted Close", xlab="Daily returns", breaks=20)

# Date format
icici$Date <- as.Date(icici$Date)

