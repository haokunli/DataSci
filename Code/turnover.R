## Data science with R ##

# Finding working directory #
getwd()

# Setting working directory #
setwd("E:/")

# Opening file (1) #
turnover <- read.csv(file="turnover.csv")

# Opening file (2) #
turnover <- read.csv("https://raw.githubusercontent.com/cinnData/DATA/master/Data/turnover.csv")

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
