## [DATA-05] SMS in Singapore Mobile ##

# Setting the working directopry (customize) #
setwd("/Users/miguel/Dropbox/Current jobs/DATA-2017-1/DATA-05")

# Loading messages #
message <- readLines("message.txt")
N <- length(message)

# Loading spam tags #
class <- readLines("class.txt")
table(class)

# Taking a look at the messages #
message[1:5]

# Lowercase #
message <- tolower(message)

# Cleaning #
message <- gsub(message, pattern="'", replacement="")
message <- gsub(message, pattern="[.]{2,3}", replacement=" dots ")
message <- gsub(message, pattern="[£$]", replacement=" pound ")
message <- gsub(message, pattern=":)", replacement=" smiley ")
message <- gsub(message, pattern="t[s ]?& ?cs?", replacement=" tconditions ")
message <- gsub(message, pattern="&lt;(#|decimal|time)&gt", replacement=" ")
message <- gsub(message, pattern="&amp;", replacement=" ")
message <- gsub(message, pattern="txt", replacement="text")
message <- gsub(message, pattern="[^a-z ]", replacement=" ")
message[1:5]

# Stripping white space #
message <- gsub(message, pattern=" +", replacement=" ")
message <- gsub(message, pattern="^ | $", replacement="")
message[1:5]

# Collecting terms #
term.list <- strsplit(message, split=" ")
term.list[1:5]

# Remove stopwords #
stopwords <- readLines("stopwords.txt")
str(stopwords)
"ur" %in% stopwords
stopwords <- c(stopwords, "arent", "aint", "cant", "couldnt", "didnt",
  "doesnt", "dont", "im", "ive", "pls", "ü", "ur")
stopRemove <- function(x) x[!(x %in% stopwords)]
term.list <- lapply(term.list, stopRemove)
term.list[1:5]

# Frequent terms #
freq.term <- sort(table(unlist(term.list)), decreasing=T)
length(freq.term)
freq.term[1:10]

# Grouping synonyms #
top10.list <- list("dots", c("call", "calling", "calls"), c("text", "texts",
  "texting"), c("pound", "pounds"), "free", "smiley", "good",
  c("day", "days"), c("ill", "illness"),
  c("love", "loves", "lovely", "loving", "lovingly"))

# Term-document matrix #
TD <- matrix(nrow=N, ncol=10)
for(i in 1:N) for(j in 1:10) TD[i,j] <- max(top10.list[[j]] %in%
  term.list[[i]])
colnames(TD) <- names(freq.term[1:10])

# Data set for predictive modelling #
sms.TD <- data.frame(spam=as.numeric(class=="spam"), TD)
head(sms.TD)

# Picking training instances (50%) #
train <- sample(1:N, size=N/2, replace=F)

# Formula #
fm <- spam ~ .

# Setting the cutoff as the spam rate #
cut <- 0.135

# Logistic regression model #
mod1 <- glm(formula=fm, data=sms.TD[train,], family="binomial")
pred1 <- predict(mod1, newdata=sms.TD[-train,], type="response")
conf1 <- table(pred1 > cut, sms.TD[-train,]$spam==1)
tp1 <- conf1["TRUE", "TRUE"]/sum(conf1[,"TRUE"])
tp1
fp1 <- conf1["TRUE", "FALSE"]/sum(conf1[,"FALSE"])
fp1

# Decision tree model #
library(rpart)
mod2 <- rpart(formula=fm, data=sms.TD[train,], cp=0.001) 
pred2 <- predict(mod2, newdata=sms.TD[-train,])
conf2 <- table(pred2 > cut, sms.TD[-train,]$spam==1)
tp2 <- conf2["TRUE", "TRUE"]/sum(conf2[,"TRUE"])
tp2
fp2 <- conf2["TRUE", "FALSE"]/sum(conf2[,"FALSE"])
fp2
