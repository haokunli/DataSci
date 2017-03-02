## Individual assignment 2 (actress) ##

# Twitter setup #
library(twitteR)
setup_twitter_oauth("9PQLhrb4ZUvte5Cb2VZRa7wce",
                    "Xxkae5otxok1j30dwPNLgScJKzvLqSKJcvU77D13azYCDmoO1D",
                    "2795394087-drbIfGPKwFZTfiNIKYXUqUrUvg1ypC2A7DfdXal",
                    "FfN5Up4WtArKoLlitGUC2ukXKElmyA7paMpYphVxGQhlP")

# Downloading function #
date1 <- "2017-02-25"
date2 <- "2017-02-26"
f <- function(string) {
  twlist <- searchTwitter(string, n=10000, since=date1, until=date2)
  twdf <- twListToDF(twlist)
  return(twdf)
}

# Isabelle Huppert data #
isabelle <- f("Huppert+Oscar")

# Ruth Negga data #
ruth <- f("Negga+Oscar")

# Natalie Portman data #
natalie <- f("Portman+Oscar")

# Emma Stone data #
emma <- f("Stone+Oscar")

# Meryl Streep data #
meryl <- f("Streep+Oscar")

# Saving actresses data #
setwd("/Users/miguel/Dropbox (Personal)/Current jobs/DATA-2017-1/Oscar 2017")
save(isabelle, ruth, natalie, emma, meryl, file="actress.RData")

# Counting tweets #
nrow(isabelle)
sum(isabelle$isRetweet)
nrow(ruth)
sum(ruth$isRetweet)
nrow(natalie)
sum(natalie$isRetweet)
nrow(emma)
sum(emma$isRetweet)
nrow(meryl)
sum(meryl$isRetweet)
