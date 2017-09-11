## Data science with R ##

# Setting working directory #
url1 <- "/Users/miguel/Dropbox (Personal)/DATA-2017-2"
url2 <- "/[DATA-02] Data science with R/"
url <- paste(url1, url2, sep="")
setwd(url)

# Opening file #
turnover <- read.csv(file="turnover.csv")

# Dimension #
dim(turnover)

# Head and tail #
head(turnover)
tail(turnover)

# Structure #
str(turnover)

# Summary #
summary(turnover)

# Function table #
table(turnover$dept)
sort(table(turnover$dept), decreasing=T)
table(turnover$dept, turnover$salary)

# Function tapply #
tapply(turnover$left, turnover$salary, mean)
tapply(turnover$left, turnover$dept, mean)
sort(tapply(turnover$left, turnover$dept, mean), decreasing=T)

# Graphical version #
barplot(tapply(turnover$left, turnover$salary, mean))

# Correlation matrix #
cor(turnover[, 1:8])
round(cor(turnover[, 1:8]), 2)

# Histogram #
hist(turnover$eval)

# Scatterplot #
plot(eval ~ hours, data=turnover)
