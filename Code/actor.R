## Individual assignment 2 (actors) ##

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

# Casey Affleck data #
casey1 <- f("Casey Affleck")
casey2 <- f("#CaseyAffleck")
casey3 <- f("@CaseyAffleck1")
casey <- rbind(casey1, casey2, casey3)
casey<- unique(casey)

# Andrew Garfield data #
andrew1 <- f("Andrew Garfield")
andrew2 <- f("#AndrewGarfield")
andrew3 <- f("@AndrewGarfieldI")
andrew <- rbind(andrew1, andrew2, andrew3)
andrew <- unique(andrew)

# Ryan Gosling data #
ryan1 <- f("Ryan Gosling")
ryan2 <- f("#RyanGosling")
ryan3 <- f("@RyanGosling")
ryan <- rbind(ryan1, ryan2, ryan3)
ryan <- unique(ryan)

# Viggo Mortensen data #
viggo1 <- f("Viggo Mortensen")
viggo2 <- f("@ViggoArt")
viggo <- rbind(viggo1, viggo2)
viggo <- unique(viggo)

# Denzel Washington data #
denzel1 <- f("Denzel Washington")
denzel2 <- f("#DenzelWashington")
denzel3 <- f("@DenzelWN")
denzel <- rbind(denzel1, denzel2, denzel3)
denzel <- unique(denzel)

# Saving actors data #
setwd("/Users/miguel/Dropbox (Personal)/Current jobs/DATA-2017-1/Oscar 2017")
save(casey, andrew, ryan, viggo, denzel, file="actor.RData")

# Counting tweets #
nrow(casey)
sum(casey$isRetweet)
nrow(andrew)
sum(andrew$isRetweet)
nrow(ryan)
sum(ryan$isRetweet)
nrow(viggo)
sum(viggo$isRetweet)
nrow(denzel)
sum(denzel$isRetweet)
 