## [DATA-01] Data science with R ##

# Start #
2 + 2
a <- 2 + 2
a

# Numeric vector #
x <- 1:10
x

# Character vector #
y <- c("Messi", "Neymar", "Cristiano")
y

# Logical vector #
z <- x > 5
z

# Factor #
y_factor <- factor(y)
y_factor

# Matrix #
A <- matrix(1:24, nrow=4)
A
A[2,3]

# List #
L <- list(L1=1:10, L2=c("Messi", "Neymar", "Cristiano"), L3=matrix(1:25, nrow=5))
L[[1]]
L$L1

# Data frame #
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
f <- function(x) 1/(1-x^2)
f(0.5)
f(1)
