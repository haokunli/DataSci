## [DATA-10P] Mining car reviews ##

# Loading reviews #
url0 <- "https://raw.githubusercontent.com/cinnData/DATA/master/IndividualAssignment-2/" 
file1 <- "reviews.txt"
url <- paste(url0, file1, sep="")
reviews <- readLines(url)
str(reviews)
reviews[1:5]
N <- length(reviews)

# Loading ratings #
file2 <- "ratings.csv"
url <- paste(url0, file2, sep="")
ratings <- read.csv(url, stringsAsFactors=F)
str(ratings)

# Loading stopwords #
file3 <- "stopwords.txt"
url <- paste(url0, file3, sep="")
stopwords <- readLines(url)
str(stopwords)

# Exploring ratings #
table(ratings$ov_rating)
table(ratings$va_rating)
table(ratings$ov_rating, ratings$va_rating)

# Cleaning #
reviews <- gsub("[$]", " dollar ", reviews) 
reviews <- gsub("…|[.]{2,}", " dots ", reviews) 
reviews <- gsub("['’]", "", reviews) 
reviews <- gsub("[^a-zA-Z]", " ", reviews) 
reviews <- tolower(reviews) 
reviews <- gsub(" {2,}", " ", reviews)
reviews <- gsub("^ | $", "", reviews)
reviews[1:5]

# Collect terms #
term.list <- strsplit(reviews, split=" ")
term.list[1:5]

# Remove stopwords #
stopwords <- readLines("stopwords.txt")
str(stopwords)
stopwords <- c(stopwords, "arent", "aint", "cant", "couldnt", "didnt", "doesnt", "dont",
               "im", "ive", "pls", "ü", "ur", "acura", "audi", "bmw", "cadillac",
               "class", "jaguar", "lexus", "mercedes", "saab", "series", "volvo")
stop.remove <- function(x) x[!(x %in% stopwords)]
term.list <- lapply(term.list, stop.remove)
term.list[1:5]

# Frequent terms #
freq.term <- sort(table(unlist(term.list)), decreasing=T)
length(freq.term)
freq.term[1:100]

# Manual stemming #
top45.list <- list(car=c("car", "cars"), great=c("great", "greater", "greatest"),
  dollar=c("dollar", "dollars"), mile=c("mile", "miles", "mileage"), 
  drive=c("drive", "drives", "driving", "driven", "drove"), good="good", dots="dots",
  problem=c("problem", "problems"), engine=c("engine", "engines"),
  buy=c("buy", "buying", "bought"), love=c("love", "loves", "loving", "lovely"),
  dealer=c("dealer", "dealers"), time=c("time", "times"), power=c("power", "powered"),
  year=c("year", "years"), back="back", luxury="luxury", price=c("price", "prices", "pricing"),
  ride=c("ride", "rides", "riding"), interior=c("interior", "interiors"),
  system=c("system", "systems"), vehicle=c("vehicle", "vehicles"),
  nice=c("nice", "nicer", "nicest"), service=c("service", "services", "servicing"),
  own=c("own", "owns", "owning", "owned"), quality="quality", seat=c("seat", "seats"),
  road=c("road", "roads"), performance="performance",
  replace=c("replace", "replaced", "replacing"),
  feel=c("feel", "feels", "felt", "feeling", "feelings"),
  handle=c("handle", "handles", "handling"), money="money", people="people",
  front="front", comfort=c("comfort", "comfortable"), warranty="warranty",
  transmission="transmission", recommend=c("recommend", "recommended"),
  month=c("month", "months"), rear="rear", lot=c("lot", "lots", "alot"),
  smooth=c("smooth", "smoother"), tire=c("tire", "tires"), wheel=c("wheel", "wheels"))

# Term-document matrix #
TD <- matrix(nrow=N, ncol=length(top45.list))
for(i in 1:N) for(j in 1:length(top45.list)) 
  TD[i, j] <- max(top45.list[[j]] %in% term.list[[i]])
colnames(TD) <- names(top45.list)

# Data set for predictive modelling #
data <- data.frame(ov_rating=ratings$ov_rating, TD)

# Correlation #
sort(cor(data)[2:46, 1])

# Predictive model (1)
fm1 <- ov_rating ~ .
mod1 <- lm(formula=fm1, data=data) 
summary(mod1)
sort(mod1$coefficients[-1])

# Evaluation function #
eval <- function(pred) {conf <- table(pred > cut, data$ov_rating==5)
tp <- conf["TRUE", "TRUE"]/sum(conf[,"TRUE"])
fp <- conf["TRUE", "FALSE"]/sum(conf[,"FALSE"])
return(c(tp, fp))
}

# Predictive model (2)  - Logistic regression #
fm2 <- as.numeric(ov_rating == 5) ~ .
cut <- mean(data$ov_rating == 5)
mod2 <- glm(formula=fm2, data=data, family="binomial")
sort(mod2$coefficients[-1])
pred2 <- predict(mod2, newdata=data, type="response")
conf2 <- table(pred2 > cut, data$ov_rating==5)
conf2
sum(diag(conf2))/sum(conf2)

# Predictive model (3) - Decision tree #
library(rpart)
mod3 <- rpart(formula=fm2, data=data)
pred3 <- predict(mod3, newdata=data)
conf3 <- table(pred3 > cut, data$ov_rating == 5)
conf3
sum(diag(conf3))/sum(conf3)

# Predictive model (4) - Logistic regression #
fm3 <- as.numeric(ov_rating < 3) ~ .
cut <- mean(data$ov_rating < 3)
mod4 <- glm(formula=fm3, data=data, family="binomial")
sort(mod4$coefficients[-1])
pred4 <- predict(mod4, newdata=data, type="response")
conf4 <- table(pred4 > cut, data$ov_rating < 3)
conf4
sum(diag(conf4))/sum(conf4)

# Predictive model (5) - Decision tree #
mod5 <- rpart(formula=fm3, data=data)
pred5 <- predict(mod5, newdata=data)
conf5 <- table(pred5 > cut, data$ov_rating < 3)
conf5
sum(diag(conf5))/sum(conf5)
