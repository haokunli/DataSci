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
twdf <- twListToDF(twlist)
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
pos.terms = scan("airlines/positive-words.txt", what="character", comment.char=";")
neg.terms = scan("airlines/negative-words.txt", what="character", comment.char=";")

# Add specific terms 
pos.terms = c(pos.terms, "smiley", "upgrade")
neg.terms = c(neg.terms, "cancel", "cancelled", "fix", "weeping", "fucked", "mechanical",
  "mistreat", "mistreated", "piss", "pissed", "shitty", "stranded", "wait", "waiting", "wtf")

# Counting functions
posCount <- function(x) sum(x %in% pos.terms)
negCount <- function(x) sum(x %in% neg.terms)

# Word splitting
term.list = strsplit(twdf$text, " ")

# Polarity (1)
positive <- unlist(lapply(termList, pos.count))
negative <- unlist(lapply(termList, neg.count))
polarity <- positive - negative

# Figure 1
plot(table(polarity), type="h", main="Figure 1. Distribution of polarity scores", 
  xlab="Polarity", ylab="Frequency")

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





















# Ignore the middle #
return(sum(polarity>=p)/sum(polarity<=-p))
}

# Summary of results
cbind(c(f('AmericanAir',1), f('Delta',1), f('JetBlue',1), f('SouthwestAir',1), f('united',1), f('USAirways',1)),
c(f('AmericanAir',2), f('Delta',2), f('JetBlue',2), f('SouthwestAir',2), f('united',2), f('USAirways',2)),
c(f('AmericanAir',3), f('Delta',3), f('JetBlue',3), f('SouthwestAir',3), f('united',3), f('USAirways',3)))

# Figure 1
pdf("fig1.pdf", width=3.5, height=3.75, pointsize=7)
plot(table(polarity), type='h', xlab='Sentiment polarity', ylab='Frequency')
dev.off()

## Alternative version

f = function(x) {
# Load data
load(file=paste(x, '.RData', sep=''))
data <- arrange(twdf, created)
data <- filter(data, isRetweet==FALSE)
# Preprocessing
docs = data$text %>% 
	function(x) iconv(enc2utf8(x), sub='byte') %>%  ##  avoid conflict with certain characters
	function(x) gsub('[[:cntrl:]]', ' ', x) %>%  ## removing control characters
	function(x) gsub('&gt;', ' ', x) %>%  ##  removing '>'
	function(x) gsub('[:][)]', ' smiley ', x) %>%  ##  replace emoticon with smiley
	function(x) gsub('[:][-][)]', ' smiley ', x) %>%  ##  replace emoticon with smiley
	function(x) gsub('[:][(]', ' weeping ', x) %>%  ##  replace emoticon with weeping
	function(x) gsub('[:][(][(]', ' weeping ', x) %>%  ##  replace emoticon with weeping
	tolower() %>%  
	function(x) gsub('(http://+[A-Za-z0-9].+)', ' ', x) %>%  ##  remove url's
	function(x) gsub('@([A-Za-z]+[A-Za-z0-9]+)', ' ', x) %>%  ##  drop Twitter usernames
	function(x) gsub('[$]', '', x) %>%  ##  drop dollar symbol
	function(x) gsub('#', ' ', x) %>%  ##  drop hashtag symbol
	function(x) gsub("&amp", " and ", x) %>%  ##  replace ampersand by 'and'
	function(x) gsub('([0-9]+[A-Za-z0-9]+)', ' ', x) %>%  ##  remove words starting with numbers
	function(x) gsub('[[:punct:]]', ' ', x) %>%	  ##  removing punctuation
	function(x) gsub('\\d+', ' ', x)  %>%  ##  remove numbers
	function(x) gsub('\\s{2,}', ' ', x)  ##  strip whitespace

# Word splitting
word.list = str_split(docs, ' ')
 
# Comparing our words to the dictionaries of positive and negative terms
pos.matches = unlist(lapply(word.list, function(x) sum(!is.na(match(x, pos.words)))))
neg.matches = unlist(lapply(word.list, function(x) sum(!is.na(match(x, neg.words)))))
polarity = (pos.matches - neg.matches)/(pos.matches + neg.matches))
return(polarity)
}

# Summary of results
data = list(f('AmericanAir'), f('Delta'), f('JetBlue'), f('SouthwestAir'), f('united'), f('USAirways'))
names(data) <- c('AmericanAir', 'Delta', 'JetBlue', 'SouthwestAir', 'united', 'USAirways')
lapply(data, function(x) mean(is.na(x), na.rm=T))
lapply(data, function(x) mean(x, na.rm=T))
c(f('AmericanAir'), f('Delta'), f('JetBlue'), f('SouthwestAir'), f('united'), f('USAirways'))

# Figure 2
pdf("fig2.pdf", width=3.5, height=3.75, pointsize=7)
hist(polarity, main='', xlab='Polarity')
dev.off()
