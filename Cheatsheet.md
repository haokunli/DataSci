### Cheatsheet

#### Input/output

- `read.csv` and `write.csv`. Import/export data from/to CSV files. By default, string data are imported as factors, but that can be stopped with `stringsAsFactors=F`.

#### Exploring a data frame

- `head` and `tail`. Fist and last rows of a data frame. Default is 6.

- `str`. Structure of an object. Applied to a data frame, it tells the type of data for each column.

- `dim`, `nrow` and `ncol`. Number of rows and/or columns of a data frame.

- `summary`. Output differs depending on the type object to which it is applied. Applied to a data frame, gives summary stats for the non-character columns of the data frame.

#### Pivot tables

- `table`. Counts the number of occurrences for each of the possible values of one or two columns of a data frame.

- `tapply`. It has three arguments: A column of a data frame that we wish to summarize by groups, the grouping variable and the function to be applied ikn the summary (e.g. the mean).

#### Correlation

- `cor`. Produces the correlation matrix of a data frame.

#### Plotting

- `barplot`. Bar plot for a numeric variable.

- `hist`. Histogram of a numeric variable.

- `plot`. It can take one or two variables. The default is `type="p"`, which uses dots.`type="l"` gives a line plot.
