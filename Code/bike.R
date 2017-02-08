# Read data set
bike <- read.csv("https://raw.githubusercontent.com/cinnData/DATA/master/Data/bike.csv")
# Display a summary of the data set - datetime is read as a factor as the default for reading is factor,
# we will prefer to have it as a string of character
str(bike)

# Read the data set and specify that the string are not factors through the 'stringAsFactors=False')
bike <- read.csv("https://raw.githubusercontent.com/cinnData/DATA/master/Data/bike.csv",stringsAsFactors=F)
# Display a summary of the data set
str(bike)

# Extract the hour from the datetime, which is in 12 and 13 position
# The substr function is extracting the chart from a string in a specific location in the structure of data, from, to)
hour <- substr(bike$datetime, 12, 13)

# display the head of the vector hour
head(hour)

# Display the graph of the mean of the registered according to the hours of the day - type='l' displays a line
plot(tapply(bike$registered, hour, mean), type="l")
# Two picks are clearly visible during the rush hours

# Check how the demand of registered is impacted by the time of the day - need to transform the hours in factor to create dummies 
summary(lm(registered ~ factor(hour), data=bike))
# R2 is 0.53

# Analyze how other data might impact the demand of registered
# Look at the demand depending on the month vs season
# Extract the month from the datetime, which is in 6 and 7 position
month <- substr(bike$datetime, 6, 7)

# Check how the demand of registered is impacted by the month - need to transform the month in factor to create dummies 
summary(lm(registered ~ factor(hour) + factor(month), data=bike))
# R2 is 0.58
# Check how the demand of registered is impacted by the season - need to transform the season in factor to create dummies 
summary(lm(registered ~ factor(hour) + factor(season), data=bike))
# R2 is 0.57
# looking at the month level improves a little bite the model compared to season

# Analyze the impact of the holiday, workingday and weekend on hour model
# display the occurrences of each type of day
table(bike$workingday, bike$holiday)/24
# there are 309 workindays, 13 holidays and 132 weekends
summary(lm(registered ~ factor(hour) + factor(month) + workingday + holiday, data=bike))
# R2 is 0.597

# Analyze the impact of the weather on the model - need to transform the weather in factor to create dummies
summary(lm(registered ~ factor(hour) + factor(month) +
             workingday + holiday + factor (weather), data=bike))
# R2 is 0.61 - p value of factor weather 4 is high

# Display the occurrences of each type of weather 
table(bike$weather)
# the type of weather 4 happened only on 1h on 1 day over the 2 years, will merge this type with the type 3
bike$weather[bike$weather==4] <- 3
table(bike$weather)
# no more type of weather 4

# Analyze the impact of the temperatures temp and atemp on our model
# Check if there is correlation between both variables
cor(bike$temp, bike$atemp)
# High correlation, we will choose one of the variable for our model

# Choose between temp and atemp
summary(lm(registered ~ factor(hour) +
             factor(month) + workingday + holiday + factor (weather) + temp, data=bike))
# R2 is 0.624
summary(lm(registered ~ factor(hour) +
             factor(month) + workingday + holiday + factor (weather) + atemp, data=bike))
# R2 is 0.623

# Define the formula for the linear regression for the model to predict the demand for registered
fm_reg <- registered ~ factor(hour) + 
  factor(month) + workingday + holiday + factor (weather) + temp + humidity + windspeed
mod_reg <- lm (formula = fm_reg, data=bike)
summary(mod_reg)
# R2 is 0.629 - the holiday variable is not relevant for this model

# Predict the demand of the registered
pred_reg <- predict (mod_reg,newdata=bike)
res_reg <- bike$registered - pred_reg

# Display the histogram of the residual values
hist(res_reg)


##----------------------------Same analysis for the casual----------------------------##


# Display the graph of the mean of the casual according to the hours of the day - type='l' displays a line
plot(tapply(bike$casual, hour, mean), type="l")
# No pick - slow increase of the usage in the morning, constant usage in the afternoon and decrease at night

# Check how the demand of casual is impacted by the time of the day - need to transform the hours in factor to create dummies 
summary(lm(casual ~ factor(hour), data=bike))
# R2 is 0.31

# Analyze how other data might impact the demand of casual
# Look at the demand depending on the month vs season
# Extract the month from the datetime, which is in 6 and 7 position
month <- substr(bike$datetime, 6, 7)

# Check how the demand of casual is impacted by the month - need to transform the month in factor to create dummies 
summary(lm(casual ~ factor(hour) + factor(month), data=bike))
# R2 is 0.42
# Check how the demand of casual is impacted by the season - need to transform the season in factor to create dummies 
summary(lm(casual ~ factor(hour) + factor(season), data=bike))
# R2 is 0.40
# looking at the month level improves a little bite the model compared to season

# Analyze the impact of the holiday, workingday and weekend on hour model
# display the occurrences of each type of day
table(bike$workingday, bike$holiday)/24
# there are 309 workindays, 13 holidays and 132 weekends
summary(lm(casual ~ factor(hour) +
             factor(month) + workingday + holiday, data=bike))
# R2 is 0.53 

# Analyze the impact of the weather on the model - need to transform the weather in factor to create dummies
summary(lm(casual ~ factor(hour) +
             factor(month) + workingday + holiday + factor (weather), data=bike))
# R2 is 0.54 - p value of factor weather 4 is high

# Display the occurrences of each type of weather 
table(bike$weather)
# the type of weather 4 happened only on 1h on 1 day over the 2 years, will merge this type with the type 3
bike$weather[bike$weather==4] <- 3
table(bike$weather)
# no more type of weather 4

# Analyze the impact of the temperatures temp and atemp on our model
# Check if there is correlation between both variables
cor(bike$temp, bike$atemp)
# High correlation, we will choose one of the variable for our model

# Choose between temp and atemp
summary(lm(casual ~ factor(hour) +
             factor(month) + workingday + holiday + factor (weather) + temp, data=bike))
# R2 is 0.566
summary(lm(casual ~ factor(hour) +
             factor(month) + workingday + holiday + factor (weather) + atemp, data=bike))
# R2 is 0.564

# Define the formula for the linear regression for the model to predict the demand for casual
fm_cas <- casual ~ factor(hour) +
  factor(month) + workingday + holiday + factor (weather) + temp + humidity + windspeed
mod_cas <- lm (formula = fm_cas, data=bike)
summary(mod_cas)
# R2 is 0.578 - the holiday variable is more relevant for this model

# Predict the demand of the registered
pred_cas <- predict (mod_cas,newdata=bike)
res_cas <- bike$casual - pred_cas

# Display the histogram of the residual values
hist(res_cas)


