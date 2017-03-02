## Individual assignment 2 (picture) ##

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

# Arrival data #
arrival <- f("Arrival+Oscar")

# Fences data #
fences <- f("Fences+Oscar")

# Hacksaw Ridge data #
hacksaw <- f("Hacksaw+Oscar")

# Hell or High Water data #
water <- f("Water+Oscar")

# Hidden Figures data #
hidden <- f("Hidden+Oscar")

# La La Land data #
lalaland <- f("Land+Oscar")

# Lion data #
lion <- f("Lion+Oscar")

# Manchester by the Sea data #
manchester <- f("Manchester+Oscar")

# Moonlight data #
moonlight <- f("Moonlight+Oscar")

# Saving actresses data #
setwd("/Users/miguel/Dropbox (Personal)/Current jobs/DATA-2017-1/Oscar 2017")
save(arrival, fences, water, hidden, lalaland, lion, manchester, moonlight,
  file="picture.RData")

# Counting tweets #
nrow(arrival)
sum(arrival$isRetweet)
nrow(fences)
sum(fences$isRetweet)
nrow(water)
sum(water$isRetweet)
nrow(hidden)
sum(hidden$isRetweet)
nrow(lalaland)
sum(lalaland$isRetweet)
nrow(lion)
sum(lion$isRetweet)
nrow(manchester)
sum(manchester$isRetweet)
nrow(moonlight)
sum(moonlight$isRetweet)
