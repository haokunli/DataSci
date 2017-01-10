## [DATA-06] Consumer attitude towards airlines ##
# Twitter setup
library(twitteR)
setup_twitter_oauth("9PQLhrb4ZUvte5Cb2VZRa7wce",
  "Xxkae5otxok1j30dwPNLgScJKzvLqSKJcvU77D13azYCDmoO1D",
  "2795394087-drbIfGPKwFZTfiNIKYXUqUrUvg1ypC2A7DfdXal",
  "FfN5Up4WtArKoLlitGUC2ukXKElmyA7paMpYphVxGQhlP")

# Downloading tweets
date1 <- as.character(Sys.Date() - 7)
date2 <- as.character(Sys.Date())
twlist = searchTwitter("@Delta", n=100, since=date1, until=date2)
twdf <- twListToDF(twlist)
str(twdf)

# Preliminaries 
setwd("/Users/miguel/Dropbox/Current jobs/DATA-2016-2/DATA-06")

# Loading data
load("Delta.RData")
ls()
str(twdf)
twdf$text[1:10]

# Preprocessing
twdf$text <- gsub(twdf$text, pattern="[[:cntrl:]]", replacement=" ") 
twdf$text <- gsub(twdf$text, pattern=":-?)", replacement=" smiley ") 
twdf$text <- gsub(twdf$text, pattern=":[(]+", replacement=" weeping ") 
twdf$text <- gsub(twdf$text, pattern="'", replacement="") 
twdf$text <- gsub(twdf$text, pattern="&([lg]t|amp);", replacement=" ") 
twdf$text <- gsub(twdf$text, pattern="http://[/a-zA-Z0-9.]+", replacement=" ") 
twdf$text <- gsub(twdf$text, pattern="@([A-Za-z]+[A-Za-z0-9]+)", replacement=" ") 
twdf$text <- gsub(twdf$text, pattern="[$#])", replacement=" ") 
twdf$text <- gsub(twdf$text, pattern="([0-9]+[A-Za-z0-9]+)", replacement=" ") 
twdf$text <- gsub(twdf$text, pattern="[[:punct:]]", replacement=" ") 
twdf$text <- gsub(twdf$text, pattern="[^a-zA-Z ]", replacement=" ")
twdf$text <- tolower(twdf$text)  
twdf$text <- gsub(twdf$text, pattern=" +", replacement=" ") 
twdf$text <- gsub(twdf$text, pattern="^ | $", replacement="") 
twdf$text[1:10]

# Liu's list of positive and negative words 
pos.terms = scan("positive-words.txt", what="character", comment.char=";")
neg.terms = scan("negative-words.txt", what="character", comment.char=";")

# Add specific terms (I should have added "small" to negatives)
pos.terms = c(pos.terms, "smiley", "upgrade")
neg.terms = c(neg.terms, "cancel", "cancelled", "fix", "weeping", "fucked", "mechanical",
  "mistreat", "mistreated", "piss", "pissed", "shitty", "stranded", "wait", "waiting", "wtf")

# Counting functions
posCount <- function(x) sum(x %in% pos.terms)
negCount <- function(x) sum(x %in% neg.terms)

# Word splitting
term.list = strsplit(twdf$text, " ")

# Polarity (1)
positive <- unlist(lapply(term.list, posCount))
negative <- unlist(lapply(term.list, negCount))
polarity <- positive - negative

# Figure 1
pdf("fig1.pdf", width=3.5, height=3.75, pointsize=7)
plot(table(polarity), type="h", main="Figure 1. Distribution of polarity scores", 
  xlab="Polarity", ylab="Frequency")
dev.off()

# Ignore the middle #
sum(polarity>=1)/sum(polarity<=-1)
sum(polarity>=2)/sum(polarity<=-2)
sum(polarity>=3)/sum(polarity<=-3)

# Discarding retweets
filter <- twdf$isRetweet==F
sum(filter)/nrow(twdf)
sum(polarity>=1 & filter)/sum(polarity<=-1 & filter)
sum(polarity>=2 & filter)/sum(polarity<=-2 & filter)
sum(polarity>=3 & filter)/sum(polarity<=-3 & filter)

# Alternative version
polarity <- (positive - negative)/(positive + negative)
sum(positive==negative & filter)/sum(filter)
mean(polarity[filter], na.rm=T)

# Figure 2
hist(polarity[filter], main='Figure 2. Distribution of polarity', xlab='Polarity')
