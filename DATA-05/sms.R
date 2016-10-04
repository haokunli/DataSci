## [DATA-05] SMS in Singapore Mobile ##
setwd("/Users/miguel/Dropbox/Current jobs/DATA-2016-2/DATA-05")

# Loading messages
message <- readLines("message.txt")
N <- length(message)

# Loading spam tags
class <- readLines("class.txt")
table(class)

# Taking a look at the messages
message[1:10]

# Lowercase
message <- tolower(message)

# Cleaning
message <- gsub(message, pattern="'", replacement="")
message <- gsub(message, pattern="[0-9]", replacement=" ")
message <- gsub(message, pattern="[.]{3}", replacement=" dots ")
message <- gsub(message, pattern="[£$]", replacement=" pound ")
message <- gsub(message, pattern=":)", replacement=" smiley ")
message <- gsub(message, pattern="t[s ]?& ?cs?", replacement=" tconditions ")
message <- gsub(message, pattern="&lt;(#|decimal|time)&gt", replacement=" ")
message <- gsub(message, pattern="&[lg]t;", replacement=" ")
message <- gsub(message, pattern="&amp;", replacement=" ")
message <- gsub(message, pattern="txt", replacement="text")
message[1:10]

# Removing punctuation 
message <- gsub(message, pattern="[[:punct:]]", replacement=" ")

# Stripping white space
message <- gsub(message, pattern=" +", replacement=" ")
message <- gsub(message, pattern="^ | $", replacement="")
message[1:10]

# Collecting terms
term.list <- strsplit(message, split=" ")
term.list[1:10]

# Remove stopwords
stopwords <- readLines("stopwords.txt")
str(stopwords)
"ur" %in% stopwords
stopwords <- c(stopwords, "arent", "aint", "cant", "couldnt", "didnt", "doesnt", "dont", "im", "ive",
  "pls", "ü", "ur")
stopRemove <- function(x) x[!(x %in% stopwords)]
term.list <- lapply(term.list, stopRemove)
term.list[1:10]

# Frequent terms
freq.term <- sort(table(unlist(term.list)), decreasing=T)
length(freq.term)
freq.term[1:10]

# Grouping synonyms
top10.list <- list("dots", c("call", "calling", "calls"), c("text", "texts", "texting"),
  c("pound", "pounds"), "free", "smiley", "good", =c("day", "days"), c("ill", "illness"),
  c("love", "loves", "lovely", "loving", "lovingly"))

# Term-document matrix
TD <- matrix(nrow=N, ncol=10)
for(i in 1:N) for(j in 1:10) TD[i,j] <- max(top10.list[[j]] %in% term.list[[i]])
colnames(TD) <- names(freq.term[1:10])
TD[1:10,]

# Data set for predictive modelling
sms.TD <- data.frame(class, TD)
str(sms.TD)

# Picking training instances (50%)
train <- sample(1:N, size=N/2, replace=F)

# Formula
fm <- class ~ .

# Evaluation function
eval <- function(pred, cut) {conf <- table(pred > cut, sms.TD[-train,]$class=="spam")
  tp <- conf["TRUE", "TRUE"]/sum(conf[,"TRUE"])
  fp <- conf["TRUE", "FALSE"]/sum(conf[,"FALSE"])
  return(c(tp, fp))
}

# Predictive modelling
mod1 <- glm(formula=fm, data=sms.TD[train,], family="binomial") # Logistic regression
pred1 <- predict(mod1, newdata=sms.TD[-train,], type="response")
library(rpart)
mod2 <- rpart(formula=fm, data=sms.TD[train,], cp=0.001) # Decision tree
pred2 <- predict(mod2, newdata=sms.TD[-train,])[,"spam"]
matrix(c(eval(pred1, 0.5), eval(pred1, 0.14), eval(pred2, 0.5), eval(pred2, 0.14)), nrow=2, byrow=T,
  dimnames = list(c("Logistic", "Tree"), c("cutoff 0.5", "", "cutoff 0.14", "")))

# Enlarged set of terms
freq.term[11:25]
top11_25.list <- list(c("time", "times"), c("send", "sending", "sender"), "home", "stop", "lor",
  "back", c("today", "todays"), "da", "reply", "mobile", c("phone", "phones"), "dear", 
  c("week", "weeks", "weekly"), c("night", "nights"), "great")

# Term-document matrix
extra.TD <- matrix(nrow=N, ncol=15)
for(i in 1:N) for(j in 1:15) extra.TD[i,j] <- max(top11_25.list[[j]] %in% term.list[[i]])
colnames(extra.TD) <- names(freq.term[11:25])
TD <- cbind(TD, extra.TD)
TD[1:10,11:25]

# Data set for predictive modelling
sms.TD <- data.frame(class, TD)

# Predictive modelling
mod1 <- glm(formula=fm, data=sms.TD[train,], family="binomial") # Logistic regression
pred1 <- predict(mod1, newdata=sms.TD[-train,], type="response")
mod2 <- rpart(formula=fm, data=sms.TD[train,], cp=0.001) # Decision tree
pred2 <- predict(mod2, newdata=sms.TD[-train,])[,"spam"]
matrix(c(eval(pred1, 0.5), eval(pred1, 0.14), eval(pred2, 0.5), eval(pred2, 0.14)), nrow=2, byrow=T,
  dimnames = list(c("Logistic", "Tree"), c("cutoff 0.5", "", "cutoff 0.14", "")))

