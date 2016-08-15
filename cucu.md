---
title: "Data Management [01]"
author: "Miguel-Angel Canela, IESE Business School"
date: "November 10, 2016"
output: 
  html_document:
    toc: false
    theme: united
---
### Introduction to R

R is a language which comes with an environment for computing and graphics, available for both Windows and Macintosh. It includes an extensive variety of techniques for statistical testing, predictive modelling and data visualization. R can be extended by hundreds of additional packages available at the **Comprehensive R Archive Network** (CRAN), which cover virtually every aspect of statistical data analysis and machine learning. 

Although it was initially restricted to the academic context, R has been gaining acceptance in the business intelligence industry in the last years: one can use R resources in Oracle, Microsoft Azure Cloud, SAP HANA, etc. It has been adopted as the default analytic tool by many well known companies such as Google, which has even written an R Style Book for its programmers.

R provides a GUI, which, called the **console**, in which we can type (or paste) our code. The console works a bit different in Macintosh and Windows. In the Windows console, what you type is in red and the R response in blue. In Macintosh, we type in blue and the response comes in black. When R is ready for our code, the console shows a **prompt** which is the symbol "greater than" (>). With the `Return` key, we finish a line of code, which is usually interpreted as request for execution. But R can detect that your input is not finished, and then it waits for more input showing a different prompt, the symbol "plus" (+). 

In an **R Markdown** document like the one that you are reading, this is usually seen as follows.

````{r}
2 + 2
```

The R console is not user-friendly, so you will probably prefer to work in an interactive developer environment (IDE). **RStudio** is the leading choice and, nowadays, most R coders prefer RStudio to the console. In RStudio, you have the console plus other windows that may help you to organize your task.

### Objects in R

R is **object-oriented**, with many classes of objects. I comment here briefly of some classes which will appear in the analysis of the examples of this course. First, we have **vectors**. A vector is an ordered collection of elements which are all of the same type. Vectors can be **numeric**, **factors** (explained later), **character** (called string in most languages), **logical** (TRUE/FALSE) or of other types not discussed in this course. The following three examples are numeric (`x`), character (`y`) and logic (`z`), respectively.

````{r}
x <- 1:10
x
y <- c("Messi", "Neymar", "Cristiano")
y
z <- x > 5
z
````

Comments on these examples:

* R distinguishes, as most languages, between integers and real numbers. Nevertheless, you can ignore this distinction unless you are dealing with very big datasets, for which the memory allocated for each record may matter. Complex numbers are in another class, but I skip them.

* The expression `c(a,b)` packs the elements `a` and `b` as the terms of a vector. This is only possible if they are of the same type. 

* The quote marks indicate character type. 

* An expression like `x > 5` is translated as a logical vector with one term for each term of `x`. 

The first term of the vector `x` can be extracted as `x[1]`, the second term as `x[2]`, etc. **Matrices** are like vectors, but two-dimensional. They can be numeric, character or logical. The terms of a matrix are identified by two indexes. For instance, `A[2,3]` is the term in the second row, third column.

```{r}
A <- matrix(1:24, nrow=4)
A
A[2,3]
```

A **data frame** (a data set) is a set of vectors (presented as columns). These vectors can have different type, but the same length. A vector of a data frame are identified as `dataframe$variable`. Rows and columns of a data frame are identified as in a matrix.


```{r}
df <- data.frame(v1=1:10, v2=10:1, v3=rep(-1,10))
df
df$v1
```

A **factor** is a numeric vector in which the values have labels, called **levels**. Factors are very natural to statisticians (stat packages, like SPSS or Stata use similar systems), but look weird to computer engineers, since programming languages don't have them.

**Dates** can be handled in many ways, including the usual date and datetime formats of databases. I will talk about this later.

Extracting parts of R objects is called is called **subsetting**. Vectors, matrices and data frames can be subsetted in an easy way. Some examples follow. 

````{r}
x[1:3]
x[x>=5]
A[1:2,3:6]
df[,-3]
df[df$v1<df$v2,]
```

R is a fully functional language. The real power of R lies in defining the operations that you wish to perform as **functions**, so they can be applied many times. For instance, import and export are usually managed by read/write functions. A simple example follows.

```{r}
f <- function(x) 1/(1+x^2)
f(1)
```

You can replace all the "arrows" (<-) by equal signs, and nothing will change. Nevertheless, it is recommended, to the beginner, to use the arrow system, to avoid mistakes. `x <- 2 + 2` is read `assign("x", 2+2)`. We can also write `2 + 2 -> x`, but `2 + 2 <- x` does not make sense. The equal sign is read as  <- (as in any programming language).

### Importing data to R

Data sets can be imported to R data frames from many formats, typically from text files, with the `read.table` function. For **csv files**, there is a special function `read.csv`. The default of `read.csv` is reading the first line of the file as the names of the variables. 

To capture the data, we have to specify a **path** in our computer or a URL. Let me illustrate with the following code, which imports a csv file containing daily OCHL (Open/Close/High/Low) data for the CNX 500 index, from 2005-01-01 to 2014-12-31, extracted from Yahoo Finance India. I perform some checks on the data frame.

```{r}
cnx <- read.csv("http://real-chart.finance.yahoo.com/table.csv?s=%5ECRSLDX&a=00&b=01&c=2005&d=11&e=31&f=2014&g=d&ignore=.csv")
dim(cnx)
head(cnx)
tail(cnx)
```

The structure of an R object can be explored with the function `str`. Note that, in this case, the variable `Date` has been imported as a factor. This is the default for importing string data in R.

````{r}
str(cnx)
```

The funtion `summary` works in different ways in objects of different nature. For numeric variables, it produces some summary statistics.

````{r}
summary(cnx)
```

As an illustration, the returns of the adjusted closing price are calculated below. The function `hist` allows exploring the distribution. 

````{r}
return <- cnx$Adj.Close[-1]/cnx$Adj.Close[-1828] - 1
hist(return, main="CNX 500 Adjusted Close", xlab="Daily returns", breaks=20)
```


