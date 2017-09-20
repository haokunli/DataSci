## Introduction to R ##

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

# List #
L <- list(L1=1:10, L2=c("Messi", "Neymar", "Cristiano"))
L[[1]]
L$L2

# Subsetting
x[1:3]
x[x>=5]

# Function
f <- function(x) 1/(1-x^2)
f(0.5)
f("Mary")
f(1)
