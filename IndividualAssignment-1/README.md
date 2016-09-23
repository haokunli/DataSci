### Comments on the assignment

* The objective of the analysis is to develop a model for predicting the price of a house from the attributes included in the data set. The data are not clean, so you could find missing values in some of the attributes. Also, real state data of this type can contain repeated data.

* The mising data are coded in R as NA. They are reported in summaries. When you fit a linear model to the data (or a part of them), the rows with missing observations in one of the variables involved in the model are ignored, reducing the sample size. If needed, detailed examination of the missing data can be carried out with the function `is.na(varname)`, which generates a logical vector (`TRUE/FALSE`) indicating where the missing values are. 

* The data set includes some categorical variables, like the neighbourhood. By default, R imports variables as categorical variables, called factors in R, unless all the non-missing observations are numeric. Factors can be explored with the function table. So, `table(factorname)` counts observations for the different outcomes of the factor. With `table(factorname1, factorname2)` you get cross-tabulation of two factors. Also, `tapply(varname, factorname, mean)` gives you the mean value of a variable for the different outcomes of a factor.

* Factors enter a regression equation as dummies. In R, there is no need of generating the dummies and to add them to the data set, R creates the dummies when running the regression and forgets them when the job is done.

* In a regression equation, you can turn a numeric variable, such as the zip, into a factor, entering it in the equation as `factor(varname)`. 
