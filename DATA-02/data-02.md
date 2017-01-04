---
title: '[DATA-02] Linear regression'
author: "Miguel-Angel Canela, IESE Business School"
date: "November 22, 2016"
output: 
  html_document:
    toc: false
    theme: united
---
### Introduction

In a data science context, the prediction of a numeric variable is called regression. Regression models are not necessarily related to a mathematical equation, as in Statistics, although this is the favourite approach for beginners. When this equation is linear, we have **linear regression**, which is the object of this lecture. Although the predictions of a linear regression model can usually be improved by more sophisticated techniques, most data scientists start there, because it helps them to understand the data.

Two alternatives to linear regression are:

* **Regression trees**. In this course, tree algorithms are discusused in a classification context, but some of them, like the CART algorithm used in the `R` package `rpart`, also apply to regression trees. 

* **Neural networks**. A neural network is a programming device whose design is based on the models developed by biologists for the brain neurons. Among the many types of neural networks, the most popular is the **multilayer perceptron** (MLP), which can be regarded as a set of (nonlinear) regression equations. In `R`, the package `nnet` provides a simple approach to MLP regression models. 

### Evaluation of a linear regression model

In general, regression models are evaluated through the prediction errors. The basic schema is
$${\rm Error}={\rm Actual\ value}-{\rm Predicted\ value}.$$

Prediction errors are called **residuals** in linear regression. In that special case, the mean of the prediction errors is zero, but this is no longer true in other models. The usual approach for estimating the regression coefficients is the **least squares method**, which minimizes the sum of the squared residuals. 

In Statistics, the predictive power of a linear regression model is evaluated through the **residual sum of squares**. The **R-squared statistic** is a standardized measure which operationalizes this. More specifically, it takes advantage of the formula
$${\rm var}\big({\rm Actual\ values}\big)={\rm var}\big({\rm Predicted\ values}\big)+
  {\rm var}\big({\rm Error}\big)$$
to evaluate the model through the proportion of **variance explained**,
$$R^2={{\rm var}\big({\rm Predicted\ values}\big)\over
  {\rm var}\big({\rm Actual\ values}\big)}\,.$$

It turns out that the square root of R-squared coincides with the **correlation** between actual values and predicted values. Although this stops being true for other regression methods, this correlation is still the simplest approach to the evaluation of a regression model.

### Dummies and factors

Categorical variables enter a regression equation through 1/0 dummies. In `R`, we can manage this in two ways:

* We can create dummies explicitly and include them in the equation (as many dummies as the number of categories minus 1). 

* We can specify the variable as a factor and put it as a single term in the formula. Then `R` creates the dummies itself, without need of changing the data set.

### Example: Windsor housing prices

In this example, I develop a pricing model for residential houses in the area of Windsor, Ontario. The data set, provided by the Windsor and Essex County Real Estate Board, covers the sales of residential houses in Windsor during July, August and September of the previous year through the Multiple Listing Service. The sample size is 546.

Besides the sale price, the data set contains information describing the key features of each house: 

* The lot size, which should play a strong role in the model.

* The number of bedrooms. 

* The number of full bathrooms (including at least the toilet, the sink and the bathtub).

* The number of stories, excluding the basement.

* The number of garage places. 

* A dummy for having a recreational room.

* A dummy for having a full and finished basement.

* A dummy for using gas for hot water heating.

* A dummy for having central air conditioning.

* A dummy for having a driveway.

* A dummy for being located in a preferred neighborhood of the city (Riverside or South Windsor).

Data sets can be imported to `R` data frames from many formats. Most of the data sets used in this course come in csv files. These are text files that use the comma as the column separator. This format is very popular, although it can lead to errors with text data. The names of the attributes are in the first row, and every other row corresponds to an instance. 

Text files are imported with the function `read.table`. For **csv files**, there is a special function called `read.csv`, which is a particular case of `read.table`. The default of `read.csv` is reading the first line of the file as the names of the variables. 

```{r, echo=F} 
setwd("/Users/miguel/Dropbox (Personal)/Current jobs/DATA-2017-1/DATA-02")
```

```{r}
windsor <- read.csv(file="windsor.csv")
```

Please, note that, where I have written `"windsor.csv"`, you have to write the complete path of this file in your computer, for the file to be found by `R`. As I am writing it, my code will work only if the file is in the **working directory**. You can change the working directory with the function `setwd`. 

A second way to import the data (you need only one way) is to do it from a remote source, using an URL. This is the case of `windsor.csv`, which is available in a GitHub repository.

```{r}
url1 <- "https://raw.githubusercontent.com/cinnData/DATA/master/DATA-02/"
url2 <- "windsor.csv"
url <- paste(url1, url2, sep="")
windsor <- read.csv(url, stringsAsFactors=F)
```

Note that I have formed the URL pasting two strings. This is not needed, but breaking code into pieces help to avoid mistakes and simplifies updating the code. The `sep` argument specifies that the *glue* to paste the two parts is the empty string (the default is a white space).

I perform some checks on the data frame.

```{r}
dim(windsor)
head(windsor)
tail(windsor)
```

Also, the structure of an `R` object can be explored with the function `str`. Actually, `windsor` is a data frame, with 546 and 11 columns.

```{r}
str(windsor)
```

A linear regression model can be obtained with the function `lm`. The key arguments are `formula` and `data`, of obvious meaning. The syntax of the formula is `y ~ x1 + x2 + ...`

```{r}
fm <- price ~ lotsize + nbdrm + nbhrm + nstor + ngar + drive + recrm + base + 
  gas + air + neigh
mod <- lm(formula=fm, data=windsor)
```

`mod` is a list. The same will be true for other models which appear in this course, for which I will not discuss their content, because that would be too technical. If you are interested in the structure of an `R` object, you can explore it with the function `names`, or (at your own risk) with `str`, which provides a lot of information but can give you too much output for complex objects. 

```{r}
names(mod)
```

In most models, the function `summary` provides useful information. for a linear regression model, it includes the regression coefficients, with the corresponding **p-values**, and the R-squared statistic, whose square root, R = 0.820, is the correlation between actual and predicted prices. 

The function `summary` also provides a summary of the residuals. The maximum and minimum have less interest, but the median (50% percentile), and the first (25% percentile) and third quartiles (75% percentile) can be useful. 

```{r}
summary(mod)
```

The predicted values of a linear regression model are actually contained in the model (the element `fitted.values`), but I use here the function `predict` in order to apply the same steps as with other models. `predict` can be applied to a new data set, as far as it contains all the variables included on the right side of the formula of the model. 

```{r}
pred <- predict(object=mod, newdata=windsor)
```

We can also examine directly the prediction errors, that is, the regression residuals,

```{r}
res <- windsor$price - pred
```

The standard deviation of the residuals is 27,807.3. Although the correlation achieved with this regression equation may look quite strong, the residual standard deviation is still the 57.2% of that of the price (48,364.5). 

```{r}
sd(res)
sd(windsor$price)
sd(res)/sd(windsor$price)
```

Another way of assessing the performance of the model is through the percentage of cases in which the error exceeds a given threshold. For instance, in this case only 12.8% of the prediction errors exceed 40,000 dollars (in absolute value), while 22.5% exceed 30,000. This allows for an assessment in dollar terms which is always helpful and may bridge the gap between the data scientist and a non-trained audience. To get this proportion, I write the expression that I want to evaluate, `abs(res1)>40000`. This creates a logical vector (`TRUE/FALSE`). When I apply `mean`, `R` transforms this vector into a dummy, so the mean gives the proportion of `TRUE` values. 

```{r}
mean(abs(res)>40000)
```

Although the price has a **skewed distribution**, that of the prediction error is reasonably symmetric, as shown in the exhibit below, obtained by as follows.

```{r}
par(mfrow=c(1,2))
hist(windsor$price, main="", xlab="Price")
hist(res, main="", xlab="Prediction error")
```

The command `par(mfrow=c(1,2))` splits the graphic device in two parts, so the next two plots will fill the two slots. With the argument `mfrow` we control the partition. The `mfrow=c(1,2)` specification means "one row, two columns". You may resize the window in your screen top take advantage of this. Note that this split looks great for the `R` console, but can produce a poor result in RStudio, unless youn resize the windows.

### Homework

Transformations, such the square root or the logarithm, are recommended in Statistics textbooks in many situations. In particular, the **log transformation**, is recommended for variables with skewed distributions, to limit the influence of extreme values. Develop a model for predicting prices which is based on a linear regression equation that has the logarithm of the price on the left side.