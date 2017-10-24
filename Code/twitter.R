## Downloading tweets ##

# Twitter setup #
library(twitteR)
setup_twitter_oauth("9PQLhrb4ZUvte5Cb2VZRa7wce",
  "Xxkae5otxok1j30dwPNLgScJKzvLqSKJcvU77D13azYCDmoO1D",
  "2795394087-drbIfGPKwFZTfiNIKYXUqUrUvg1ypC2A7DfdXal",
  "FfN5Up4WtArKoLlitGUC2ukXKElmyA7paMpYphVxGQhlP")

# Downloading tweets #
twlist = searchTwitter("messi", n=100, since="2017-10-23", until="2017-10-24")
twdf <- twListToDF(twlist)
dim(twdf)
names(twdf)

## Customer attitude towards airlines ##

# Reading Twitter data (customize) #
setwd("C:/Users/mcanela/Dropbox (Personal)/DATA-2017-2/[DATA-07] Sentiment analysis")
load("Delta.RData")
ls()
twdf$text[1:5]

# Preprocessing #
library(stringr)
twdf$text <- str_replace_all(twdf$text, "[[:cntrl:]]", " ")
twdf$text <- str_replace_all(twdf$text, ":-?[)]", " smiley ")
twdf$text <- str_replace_all(twdf$text, ":[(]+", " weeping ")
twdf$text <- str_replace_all(twdf$text, "'", "")
twdf$text <- str_replace_all(twdf$text, "&[a-z]+;", " ")
twdf$text <- str_replace_all(twdf$text, "http://[/a-zA-Z0-9.]+", " ")
twdf$text <- str_replace_all(twdf$text, "@([A-Za-z]+[A-Za-z0-9]+)", " ")
twdf$text <- str_replace_all(twdf$text, "[$#]", " ")
twdf$text <- str_replace_all(twdf$text, "([0-9]+[A-Za-z0-9]+)", " ")
twdf$text <- str_replace_all(twdf$text, "[^a-zA-Z ]", " ")
twdf$text <- str_to_lower(twdf$text)
twdf$text <- str_replace_all(twdf$text, " +", " ")
twdf$text <- str_replace_all(twdf$text, "^ | $", "")
twdf$text[1:5]

# Liu's list of positive and negative words #
pos.terms <- readLines("positive-words.txt")
neg.terms <- readLines("negative-words.txt")

# Add specific terms (I should have added "small" to negatives) #
pos.terms <- c(pos.terms, "smiley", "upgrade")
neg.terms <- c(neg.terms, "cancel", "cancelled", "fix", "weeping",
  "fucked", "mechanical", "mistreat", "mistreated", "piss", "pissed",
  "shitty", "stranded", "wait", "waiting", "wtf")

# Counting functions #
posCount <- function(x) sum(unlist(str_split(x, " ")) %in% pos.terms)
negCount <- function(x) sum(unlist(str_split(x, " ")) %in% neg.terms)

# Polarity (1) #
positive <- sapply(twdf$text, posCount, USE.NAMES=F)
negative <- sapply(twdf$text, negCount, USE.NAMES=F)
polarity <- positive - negative

# Figure 1 #
barplot(table(polarity), main="Figure 1. Distribution of polarity",
  xlab="Polarity", ylab="Frequency")

# Polarity measure for Delta #
sum(polarity > 0)/sum(polarity < 0)

# Discarding retweets #
sum(twdf$isRetweet)/nrow(twdf)
sum(polarity > 0 & !twdf$isRetweet)/sum(polarity < 0 &
  !twdf$isRetweet)

# Polarity (2) #
polarity <- (positive - negative)/(positive + negative)
mean(polarity, na.rm=T)
mean(polarity[!twdf$isRetweet], na.rm=T)

# Figure 2 #
hist(polarity,
  main="Figure 2. Distribution of polarity (alternative)",
  xlab="Polarity")
