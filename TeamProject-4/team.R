#Retrieve users data
users <- read.csv("C:/Users/presentaciones/Downloads/users.csv")

N <- length(users$country_destination)

#Convert country_destination to booking (yes/no) to simplify model
users$booking <- ifelse(users$country_destination == "NDF",0,1)
table(users$booking)

#Create month account created vector
users$month_created <- substr(users$date_account_created,6,7)
users$month_created <- as.numeric(users$month_created)
tapply(users$booking==1, users$month_created, mean)

#Create year account created
users$year_created <- substr(users$date_account_created,3,4)
users$year_created <- as.numeric(users$year_created)
tapply(users$booking==1, users$year_created, mean)

#Group gender data
users$gender <- gsub("OTHER","-unknown-",users$gender)
table(users$gender)

#Binary Age information (known/unknown)
table(users$age)
users$age_info <- ifelse(users$age > 70, NA, ifelse(users$age < 15, NA, users$age))
users$age_info <- ifelse(is.na(users$age_info) == TRUE, 0, 1)
table(users$age_info)

#Group sign up method (basic/other)
tapply(users$booking == 1, users$signup_method, mean)
users$signup_method <- gsub("facebook","other",users$signup_method)
users$signup_method <- gsub("google","other",users$signup_method)
tapply(users$booking == 1, users$signup_method, mean)

#Group signup  flow (0/other)
tapply(users$booking==1, users$signup_flow, mean)
users$signup_flow_direct <- ifelse(users$signup_flow == "0", 1, 0)
tapply(users$booking==1, users$signup_flow_direct, mean)

#Group languange to English or not
tapply(users$booking==1, users$language, mean)
users$language_en <- ifelse(users$language == "en", 1, 0)
tapply(users$booking==1, users$language_en, mean)

#Group affiliate Channel
tapply(users$booking==1, users$affiliate_channel, mean)
users$affiliate_channel <- gsub("content","other",users$affiliate_channel)
users$affiliate_channel <- gsub("api","other",users$affiliate_channel)
users$affiliate_channel <- gsub("remarketing","other",users$affiliate_channel)
users$affiliate_channel <- gsub("seo","other",users$affiliate_channel)
tapply(users$booking==1, users$affiliate_channel, mean)

#Group affiliate provider
tapply(users$booking==1,users$affiliate_provider,mean)
users$affiliate_provider <- gsub("baidu", "other", users$affiliate_provider)
users$affiliate_provider <- gsub("bing", "other", users$affiliate_provider)
users$affiliate_provider <- gsub("craigslist", "other", users$affiliate_provider)
users$affiliate_provider <- gsub("daum", "other", users$affiliate_provider)
users$affiliate_provider <- gsub("email-marketing", "other", users$affiliate_provider)
users$affiliate_provider <- gsub("facebook-open-graph", "facebook", users$affiliate_provider)
users$affiliate_provider <- gsub("facebook", "other", users$affiliate_provider)
users$affiliate_provider <- gsub("gsp", "other", users$affiliate_provider)
users$affiliate_provider <- gsub("meetup", "other", users$affiliate_provider)
users$affiliate_provider <- gsub("naver", "other", users$affiliate_provider)
users$affiliate_provider <- gsub("padmapper", "other", users$affiliate_provider)
users$affiliate_provider <- gsub("vast", "other", users$affiliate_provider)
users$affiliate_provider <- gsub("wayn", "other", users$affiliate_provider)
users$affiliate_provider <- gsub("yahoo", "other", users$affiliate_provider)
users$affiliate_provider <- gsub("yandex", "other", users$affiliate_provider)
tapply(users$booking==1,users$affiliate_provider,mean)

#Group affiliate tracked
tapply(users$booking==1,users$first_affiliate_tracked,mean)
users$first_affiliate_tracked <- gsub("local ops", "tracked-other", users$first_affiliate_tracked)
users$first_affiliate_tracked <- gsub("marketing", "tracked-other", users$first_affiliate_tracked)
users$first_affiliate_tracked <- gsub("product", "tracked-other", users$first_affiliate_tracked)
tapply(users$booking==1,users$first_affiliate_tracked,mean)

#Group first device type (Phone, Tablet, Desktop, Unknown)
tapply(users$booking==1,users$first_device_type,mean)
users$first_device_type <- gsub("Android Phone", "Phone",users$first_device_type)
users$first_device_type <- gsub("iPhone", "Phone",users$first_device_type)
users$first_device_type <- gsub("SmartPhone [(]Other[)]", "Phone",users$first_device_type)
users$first_device_type <- gsub("Android Tablet", "Tablet",users$first_device_type)
users$first_device_type <- gsub("iPad", "Tablet",users$first_device_type)
users$first_device_type <- gsub("Mac Desktop", "Desktop",users$first_device_type)
users$first_device_type <- gsub("Windows Desktop", "Desktop",users$first_device_type)
users$first_device_type <- gsub("Desktop [(]Other[)]", "Desktop",users$first_device_type)
tapply(users$booking==1,users$first_device_type,mean)

#Group first browser
tapply(users$booking==1,users$first_browser,mean)
users$first_browser <- gsub("Android Browser","Other",users$first_browser)
users$first_browser <- gsub("AOL Explorer","Other",users$first_browser)
users$first_browser <- gsub("Apple Mail","Other",users$first_browser)
users$first_browser <- gsub("Arora","Other",users$first_browser)
users$first_browser <- gsub("Avant Browser","Other",users$first_browser)
users$first_browser <- gsub("BlackBerry Browser","Other",users$first_browser)
users$first_browser <- gsub("Camino","Other",users$first_browser)
users$first_browser <- gsub("Chrome Mobile","Other",users$first_browser)
users$first_browser <- gsub("Chromium","Other",users$first_browser)
users$first_browser <- gsub("CometBird","Other",users$first_browser)
users$first_browser <- gsub("Comodo Dragon","Other",users$first_browser)
users$first_browser <- gsub("Conkeror","Other",users$first_browser)
users$first_browser <- gsub("CoolNovo","Other",users$first_browser)
users$first_browser <- gsub("Crazy Browser","Other",users$first_browser)
users$first_browser <- gsub("Epic","Other",users$first_browser)
users$first_browser <- gsub("Flock","Other",users$first_browser)
users$first_browser <- gsub("Google Earth","Other",users$first_browser)
users$first_browser <- gsub("Googlebot","Other",users$first_browser)
users$first_browser <- gsub("IceDragon","Other",users$first_browser)
users$first_browser <- gsub("IceWeasel","Other",users$first_browser)
users$first_browser <- gsub("IE Mobile","Other",users$first_browser)
users$first_browser <- gsub("Iron","Other",users$first_browser)
users$first_browser <- gsub("Kindle Browser","Other",users$first_browser)
users$first_browser <- gsub("Maxthon","Other",users$first_browser)
users$first_browser <- gsub("Mobile Firefox","Other",users$first_browser)
users$first_browser <- gsub("Mozilla","Firefox",users$first_browser)
users$first_browser <- gsub("NetNewsWire","Other",users$first_browser)
users$first_browser <- gsub("OmniWeb","Other",users$first_browser)
users$first_browser <- gsub("Opera[ ]Mini","Other",users$first_browser)
users$first_browser <- gsub("Opera[ ]Mobile","Other",users$first_browser)
users$first_browser <- gsub("Opera","Other",users$first_browser)
users$first_browser <- gsub("Outlook 2007","Other",users$first_browser)
users$first_browser <- gsub("Pale Moon","Other",users$first_browser)
users$first_browser <- gsub("Palm Pre web browser","Other",users$first_browser)
users$first_browser <- gsub("PS Vita browser","Other",users$first_browser)
users$first_browser <- gsub("RockMelt","Other",users$first_browser)
users$first_browser <- gsub("SeaMonkey","Other",users$first_browser)
users$first_browser <- gsub("Silk","Other",users$first_browser)
users$first_browser <- gsub("SiteKiosk","Other",users$first_browser)
users$first_browser <- gsub("SlimBrowser","Other",users$first_browser)
users$first_browser <- gsub("Sogou Explorer","Other",users$first_browser)
users$first_browser <- gsub("Stainless","Other",users$first_browser)
users$first_browser <- gsub("TenFourFox","Other",users$first_browser)
users$first_browser <- gsub("TheWorld Browser","Other",users$first_browser)
users$first_browser <- gsub("wOSBrowser","Other",users$first_browser)
users$first_browser <- gsub("Yandex.Browser","Other",users$first_browser)
tapply(users$booking==1,users$first_browser,mean)

#Determine formula
fm <- booking ~ year_created + month_created + gender + age_info + 
  signup_method + signup_flow_direct + language_en + affiliate_channel + 
  affiliate_provider + first_affiliate_tracked + signup_app + 
  first_device_type + first_browser

#Set training instances
train <- sample(1:N, size=N/2, replace=F) #Setting training instances

#Predictive modelling
library(rpart)

#Logistic regression
mod1 <- glm(fm, data=users[train,], family="binomial")
pred1 <- predict(mod1, newdata = users[-train,], type="response")

#Decision tree
mod2 <- rpart(formula=fm, data=users[train,],cp=0.001)
pred2 <- predict(mod2, newdata=users[-train,])

#Evaluation function
eval <- function(pred, cut) {conf <- table(pred > cut, users[-train,]$booking==1)
  tp <- conf["TRUE", "TRUE"]/sum(conf[,"TRUE"])
  fp <- conf["TRUE", "FALSE"]/sum(conf[,"FALSE"])
  return(c(tp, fp))
}

#for cutoff 0.4 and 0.3
matrix(c(eval(pred1, 0.4), eval(pred1, 0.3), eval(pred2, 0.4), eval(pred2, 0.3)), nrow=2, byrow=T,
       dimnames = list(c("Logistic", "Tree"), c("cutoff 0.4", "", "cutoff 0.3", "")))
