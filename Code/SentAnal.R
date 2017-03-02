## Individual assignment 2 (sentiment analysis) ##

# Preliminaries #
setwd("/Users/miguel/Dropbox (Personal)/Current jobs/DATA-2017-1/Oscar 2017")

# Loading data #
load("picture.RData")
ls()

# Polarity function #
g <- function(movie) {
  # Preprocessing
  movie$text <- gsub(movie$text, pattern="[[:cntrl:]]", replacement=" ") 
  movie$text <- gsub(movie$text, pattern=":-?)", replacement=" smiley ") 
  movie$text <- gsub(movie$text, pattern=":[(]+", replacement=" weeping ") 
  movie$text <- gsub(movie$text, pattern="'", replacement="") 
  movie$text <- gsub(movie$text, pattern="&([lg]t|amp);", replacement=" ") 
  movie$text <- gsub(movie$text, pattern="http://[/a-zA-Z0-9.]+", 
    replacement=" ") 
  movie$text <- gsub(movie$text, pattern="@([A-Za-z]+[A-Za-z0-9]+)",
    replacement=" ")
  movie$text <- gsub(movie$text, pattern="([0-9]+[A-Za-z0-9]+)",
    replacement=" ") 
  movie$text <- gsub(movie$text, pattern="[^a-zA-Z ]", replacement=" ")
  movie$text <- tolower(movie$text)  
  movie$text <- gsub(movie$text, pattern=" +", replacement=" ") 
  movie$text <- gsub(movie$text, pattern="^ | $", replacement="") 
  movie$text[1:5]
  # Liu's list of positive and negative words 
  pos.terms = readLines("positive-words.txt")
  neg.terms = readLines("negative-words.txt")
  # Add specific terms
  pos.terms = c(pos.terms, "smiley")
  neg.terms = c(neg.terms, "weeping", "fucked", "piss", "pissed", "shitty")
  # Counting functions
  posCount <- function(x) sum(unlist(strsplit(x, split=" ")) %in% pos.terms)
  negCount <- function(x) sum(unlist(strsplit(x, split=" ")) %in% neg.terms)
  # Polarity
  positive <- sapply(movie$text, posCount, USE.NAMES=F)
  negative <- sapply(movie$text, negCount, USE.NAMES=F)
  polarity <- positive - negative
  polarity_ratio <- sum(polarity>=1)/sum(polarity<=-1)
  return(polarity_ratio)
}

# Polarity evaluation #
g(arrival)
g(fences)
g(hacksaw)
g(water)
g(hidden)
g(lalaland)
g(lion)
g(manchester)
g(moonlight)

# Discarding retweets #
h <- function(movie) g(movie[movie$isRetweet==F, ])
h(arrival)
h(fences)
h(hacksaw)
h(water)
h(hidden)
h(lalaland)
h(lion)
h(manchester)
h(moonlight)
