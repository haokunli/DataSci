## Text analysis for Yelp reviews ##

# Resources #
library(stringr)

# Setting working directory #
setwd("/Users/miguel/Dropbox (IESE)/Data archive/Yelp downloads")
setwd("C:/Users/mcanela/Dropbox (Personal)/DATA-2018-1/[DATA-06] Text mining - Tacos")

# Reading data #
tacos <- read.csv("tacos.csv", stringsAsFactors=F)
str(tacos)
stopwords <- readLines("stopwords.txt")

# Ranking restaurants #
sort(tapply(tacos$rating, tacos$restaurant, mean), decreasing=T)
table(tacos$restaurant, tacos$rating)

# Length of the messages #
tapply(str_length(tacos$review), tacos$rating, mean)
sort(tapply(str_length(tacos$review), tacos$restaurant, mean))
cor(str_length(tacos$review), tacos$rating)

# Preprocessing #
review <- tacos$review
review <- str_replace_all(review, "'", "")
review <- str_to_lower(review)
review <- str_replace_all(review, "coca-cola", "coke")
review <- str_replace_all(review, "guacamole", "guac")
review <- str_replace_all(review, "[^a-zA-Z ]", " ")
review <- str_replace_all(review, " +", " ")
review <- str_trim(review)
review[1]

# Term list #
term_list <- str_split(review, " ")
term_list[1]
stopwords <- c(stopwords, "arent", "aint", "cant", "couldnt", "didnt",
  "doesnt", "dont", "havent", "hasnt", "im", "ive", "thats", "theyre",
  "wasnt", "whos", "youre", "arriba","donna", "dylan", "esquina",
  "villalobos", "montclair", "sunnyside")
stopRemove <- function(x) x[!(x %in% stopwords)]
term_list <- lapply(term_list, stopRemove)

# Frequent terms #
freq_term <- sort(table(unlist(term_list)), decreasing=T)
length(freq_term)
freq_term[1:100]

# Grouping synonyms #
top_terms <- list(food="food", good="good", place="place",
  taco=c("taco", "tacos"), great="great", service="service", bar="bar",
  drink=c("drink", "drinks", "drinking"),
  time=c("time", "times", "timely"), mexican="mexican", nice="nice",
  menu="menu", night="night", order=c("order", "ordered", "ordering"),
  restaurant="restaurant", chips="chips", delicious="delicious",
  guac="guac", love=c("love", "lovely", "loving"),
  people="people", staff="staff", chicken="chicken",
  table=c("table", "tables"), make=c("make", "makes", "made"),
  small="small", salsa="salsa",
  friend=c("friend", "friends", "friendly"), music="music",
  fresh="fresh", margarita=c("margarita", "margaritas"),
  waiter=c("waiter", "waitress"), fish="fish", hour=c("hour", "hours"),
  dinner="dinner", give=c("give","gives", "gave", "giving", "given"),
  ask=c("ask", "asks", "asking", "asked"), bad="bad",
  cocktail=c("cocktail", "coktail", "cocktails"))

# Replacing synonyms #
f <- function(x, t) ifelse(x %in% t, t[1], x)
for(t in top.terms) term.list <- lapply(term.list, function(x)
  f(x, t))

# Updating frequent terms #
freq.term <- sort(table(unlist(term.list)), decreasing=T)
freq.term[1:100]

# Term-document matrix #
p <- length(top.terms)
N <- length(review)
TD <- matrix(nrow=N, ncol=p)
for(i in 1:N) for(j in 1:p) TD[i,j] <- max(top.terms[[j]]
  %in% term.list[[i]])
colnames(TD) <- names(top.terms)

# Correlation analysis #
data <- data.frame(restaurant=tacos$restaurant, TD)
sort(round(cor(data[,-1])[-1,1], 2))

# Separate analyses #
data1 <- data[data$restaurant=="Arriba Arriba Sunnyside", -(1:2)]
sort(apply(data1, 2, sum))
sort(round(cor(data1[,-1])[-1,1], 2))
data2 <- data[data$restaurant=="Donna", -(1:2)]
sort(apply(data2, 2, sum))
sort(round(cor(data2[,-1])[-1,1], 2))
data3 <- data[data$restaurant=="Dylan Murphy's", -(1:2)]
sort(apply(data3, 2, sum))
sort(round(cor(data3[,-1])[-1,1], 2))
data4 <- data[data$restaurant=="La Esquina", -(1:2)]
sort(apply(data4, 2, sum))
sort(round(cor(data4[,-1])[-1,1], 2))
data5 <- data[data$restaurant=="Villalobos", -(1:2)]
sort(apply(data5, 2, sum))
sort(round(cor(data5[,-1])[-1,1], 2))

# Word-pairs #
pairWord <- function(x) str_c(x[-length(x)], x[-1], sep="_")
pair.list <- lapply(term.list, pairWord)
freq.pair <- sort(table(unlist(pair.list)), decreasing=T)
freq.pair[1:100]

# Grouping pairs #
top.pairs <- list(happy_hour="happy_hour",
  good_food=c("good_food", "food_good", "great_food", "food_great",
    "food_delicious", "delicious_food"),
  mexican_food="mexican_food",
  fish_taco="fish_taco", rice_beans="rice_beans",
  shrimp_taco="shrimp_taco", order_taco=c("order_taco", "taco_order"),
  pretty_good="pretty_good", chips_salsa="chips_salsa",
  saturday_night="saturday_night",
  love_place=c("love_place", "great_place", "place_great",
    "place_good"))

# Pair-document matrix #
p <- length(top.pairs)
N <- length(review)
PD <- matrix(nrow=N, ncol=p)
for(i in 1:N) for(j in 1:p) PD[i,j] <- max(top.pairs[[j]] %in%
  pair.list[[i]])
colnames(PD) <- names(top.pairs)
