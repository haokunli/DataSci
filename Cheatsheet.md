### Cheatsheet

#### Input/output

- `read.csv` and `write.csv`. Import/export data from/to CSV files. By default, string data are imported as factors, but that can be stopped with `stringsAsFactors=F`.

#### Exploring a data frame

- `head` and `tail`. Fist and last frows of a data frame. Default is 6.

- `str`. Structure of an object. Applied to a data frame, it tells the type of data for each column.

- `dim`, `nrow` and `ncol`. Number of rows and/or columns of a data frame.

- `summary`. Output differs depending on the type object to which it is applied. Applied to a data frame gives summary stats for the non-character columns of the data frame.

- `names`. Some `R` objects are just lists where other are packed. The function `names` gives the names of the objects in the list. For instance, a data frame is a list of vectors of the same length. So, applied to a data set, `names` gives the names of the vectors that form the data frame.

#### Pivot tables

- `table`. Counts the number of occurrences for each of the possible values of one or two columns of a data frame.

- `tapply`. It has three arguments: A column of a data frame that we wish to summarize by groups, the grouping variable and the function to be applied in the summary (e.g. the mean).

#### Statistics

- `cor`. Applied to a data frame, it produces the correlation matrix of that data frame. Applied to a pair of vectors, it gives the correlation of the two vectors. Warning: It gives trouble if there are missing values (NA). Check `help(cor)` in that case.

- `mean`, `median`, `sd` and `sum`. They give the mean, median, standard deviation and sum, respectively.  Warning: They give trouble if there are missing values.

#### Plotting

- `barplot`. Bar plot for a numeric variable.

- `hist`. Histogram of a numeric variable. Arguments `main`, `xlab` and `ylab` specify the title and the labels for the X and Y axis, respectively.

- `plot`. It can take one or two variables. The default is `type="p"`, which uses dots.`type="l"` gives a line plot. The size and shape of the dots can be changed with the argument `pch`.

#### Linear regression

- `lm`. It gives an `lm` object, which is a list containing various objects related to linear regression, such as the coefficients, the predicted values, the residuals, etc. There many ways of specifying a linear model. Probably the simplest approach is to use the two arguments: (a) `formula`, to specify the equation, as in `formula = y ~ x1 + x2` and (b) `data`, as in `data = df`.

- `predict`. In general, this function can be applied to a variety of predictive models, giving *predicted values*. In the simple version, it uses two arguments: (a) `object`, to specify the name of the model, and (b) `newdata`, to specify the name of the data frame used for the predictions, which can be the same data frame on which the model was obtained, or a fresh one.
