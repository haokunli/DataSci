## [DATA-06] Consumer attitudes towards airlines ##
# Preliminaries #
setwd("/Users/miguel/Dropbox/Current jobs/DATA-2016/DATA-06")
library(twitteR)
library(dplyr)
library(stringr)

# List of Twitter names: @AmericanAir, @Delta, @JetBlue, @SouthwestAir, @united, @USAirways

# Twitter setup
setup_twitter_oauth("M7psOaFhl3psNX82qp3ljD6gi", "b78RsEe81pPNHzBqnWZVqCyJ43IPyq1dnVWvG4kh3WBVKjAeQW",
	"2795394087-bVztr1gmswxuDs0pnDMkKeOVes4HQPRcja69pzu", "EiKV3BaxvExUpcLamasDyTZByKoUbpXX78hQHEs6SK8uP")

# Downloading tweets 
f = function(x) {
	twlist = searchTwitter(x, n=100, since='2016-03-05', until='2016-03-12')
	twdf <- twListToDF(twlist)
	save(twdf, file=paste(x, '.RData', sep=''))
}
f('AmericanAir'); f('Delta'); f('JetBlue'); f('SouthwestAir'); f('united'); f('USAirways')

# Descriptive statistics
load("Delta.RData")
data <- arrange(twdf, created)
names(data)
TBT = as.numeric(diff(data$created))  ##  Time between tweets, times are format POSIXct, UTC/GMT times (Greenwich)
hist(TBT)
median(TBT)
plot(TBT[1:1000], type="l", xlab="", ylab='Time between tweets (seconds)')

# Liu's list of positive and negative words #
hu.liu.pos = scan('positive-words.txt', what='character', comment.char=';')
hu.liu.neg = scan('negative-words.txt', what='character', comment.char=';')

# Add specific terms #
pos.words = c(hu.liu.pos, 'smiley', 'upgrade')
neg.words = c(hu.liu.neg, 'cancel', 'cancelled', 'fix', 'weeping', 'fucked', 'mechanical', 'mistreat', 'mistreated',
	'piss', 'pissed', 'shitty', 'stranded', 'wait', 'waiting', 'wtf')

f = function(x,p) {
# Load data
load(file=paste(x, '.RData', sep=''))
str(twdf)
# Preprocessing
docs = twdf$text %>% 
	tolower() %>%  
	function(x) gsub("[[:cntrl:]]", " ", x) %>%	
	function(x) gsub(x, pattern=":-?[)]", replacement=" smiley ") %>%  
	function(x) gsub(x, pattern=":[(]+", replacement=" weeping ") %>% 
	function(x) gsub(x, "&([lg]t|amp);", " ") %>%  ## 
	function(x) gsub("&amp", " and ", x) %>%  ##  replace ampersand by 'and'

	function(x) [iconv(enc2utf8(x), sub='byte')] %>%  ##  avoid conflict with certain characters
	function(x) gsub('http://[/A-Za-z0-9.]+', ' ', x) %>%  ##  remove url's
	function(x) gsub('@([A-Za-z]+[A-Za-z0-9]+)', ' ', x) %>%  ##  drop Twitter usernames
	function(x) gsub('[$#]', '', x) %>%  ##  drop dollar and hashtag symbols
	function(x) gsub('([0-9]+[A-Za-z0-9]+)', ' ', x) %>%  ##  remove words starting with numbers
	function(x) gsub('[[:punct:]]', ' ', x) %>%	  ##  removing punctuation
	function(x) gsub('\\d+', ' ', x)  %>%  ##  remove numbers
	function(x) gsub('\\s{2,}', ' ', x)  ##  strip whitespace

# Word splitting
word.list = str_split(docs, ' ')
 
# Comparing our words to the dictionaries of positive and negative terms
pos.matches = unlist(lapply(word.list, function(x) sum(!is.na(match(x, pos.words)))))
neg.matches = unlist(lapply(word.list, function(x) sum(!is.na(match(x, neg.words)))))
polarity = pos.matches - neg.matches

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
