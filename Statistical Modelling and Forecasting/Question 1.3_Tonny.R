rm(list = ls()) # clears all objects in the workspace


#*****************DATA LOADING AND PREPARTION******************


mydata <- read.csv('C:\\Users\\tonny\\Downloads\\kc_house_data.csv\\kc_house_data.csv')
mydata$date <- as.POSIXct(mydata$date, format="%Y%m%dT%H%M%S")


# set your personal seed
set.seed(1088)
# create a vector of TRUE FALSE with probability 0.80 and 0.20
index <- sample(c("TRUE","FALSE"), dim(mydata)[1], replace = TRUE,
                prob=c(0.8, 0.2))
# make sure it is a logical vector
index <- as.logical(index)
# select the subset
df <- subset(mydata,index)
# check the dimensions of the new data
dim(df)
# see the first 5 rows
head(df, 5)

colnames(df)

#*****************DATA CLEANING******************




#Calculate the correlation matrix
install.packages('corrplot')
library(corrplot)
corr_matrix <- cor(df)

# Dropping specific columns
install.packages('dplyr')
library(dplyr)
df <- select(df,-id,-date,-lat,-long,-zipcode,-yr_renovated,-sqft_above,-sqft_lot15, sqft_living15) 


#"sqft_living" and "sqft_above" are highly correlated
#as both of them represent the total area of the house so dropping them as well.

#(The main reason to drop sqft_lot15 variable is that it represents 
#the lot size of the nearest 15 neighbors of the house, which may 
#not be relevant to predicting the price of the house. The lot size
#of neighboring houses may have little impact on the price of 
#a particular house, as it depends on many other factors such as the 
#location, condition, and amenities of the house. Additionally, 
#the sqft_lot variable already represents the lot size of the house, 
#making sqft_lot15 redundant. Therefore, dropping sqft_lot15 would 
#simplify the model without losing any relevant information.)

new_corr_matrix <- cor(df)

#*****************DATA VISUALISATION******************

#correlation matrix plot
corrplot(new_corr_matrix, method = "color", tl.col = "black", tl.srt = 80, addCoef.col = "black")


# create histogram
ggplot(df, aes(x = price)) + 
  geom_histogram(binwidth = 1000, color = "blue") + 
  labs(title = "Histogram of Price", x = "Price")

# create normal probability plot
qqPlot(df$price, main="Normal Probability Plot of Price")

# create Scatter plot
par(mfrow=c(4,4), mar=c(2, 2, 1, 1), oma=c(0, 0, 2, 0))
for(i in 2:15){
  plot(df[[i]], df$price, xlab = names(df[i]), ylab = "price", main = paste("price against.", names(df[i])))
}

#*****************DATA ANALYSIS******************

colnames(df)
formula <- as.formula("price ~ bedrooms + bathrooms + sqft_living +sqft_lot+floors+waterfront+view+condition+grade+sqft_basement+yr_built+sqft_living15")

# Check the skewness of the transformed variable

#Checking Skewness 
install.packages(moments)
library(moments)
skewness(df$price)
df$log_price <- log(df$price)
skewness(df$log_price)


#Since Price is heavily skewed we are doing a log transformation
df$log_price <- log(df$price)

install.packages("gamlss")
library(gamlss)

mbct <- gamlss(log_price ~ bedrooms + bathrooms + sqft_living +sqft_lot+floors+waterfront+view+condition+grade+sqft_basement+yr_built+sqft_living15, data = df, family = BCT())
mga <- gamlss(log_price ~ bedrooms + bathrooms + sqft_living +sqft_lot+floors+waterfront+view+condition+grade+sqft_basement+yr_built+sqft_living15, data = df, family = GA())
mno <- gamlss(log_price ~ bedrooms + bathrooms + sqft_living +sqft_lot+floors+waterfront+view+condition+grade+sqft_basement+yr_built+sqft_living15, data = df, family = NO())
mexp <- gamlss(log_price ~ bedrooms + bathrooms + sqft_living +sqft_lot+floors+waterfront+view+condition+grade+sqft_basement+yr_built+sqft_living15, data = df, family = EXP())

# Add fitted values to original dataset
df$mbct_fitted <- fitted(mbct)
df$mga_fitted <- fitted(mga)
df$mno_fitted <- fitted(mno)
df$mexp_fitted <- fitted(mexp)



plot(mbct, which = 1, type = "1") # fitted distribution
plot(mga, which = 1, type = "l") # fitted distribution
plot(mno, which = 1, type = "l") # fitted distribution
plot(mexp, which = 1, type = "l") # fitted distribution





# Calculate GAIC for each model
gaic_mbct <- GAIC(mbct)
gaic_mga <- GAIC(mga)
gaic_mno <- GAIC(mno)
gaic_mexp <- GAIC(mexp)

gaic_values <- c(gaic_mbct, gaic_mga, gaic_mno, gaic_mexp)
model_names <- c("MBCT", "GA", "NO", "EXP")
df_gaic <- data.frame(model_names, gaic_values)
df_gaic <- df_gaic[order(df_gaic$gaic_values),]
df_gaic

summary(mbct)
summary(mga)
summary(mno)
summary(mexp)

#***************MAKING PREDICTIONS*******************
# Extract the first observation from the out-of-sample dataset
new_obs <- df[which(index == FALSE)[1], ]
# Use the mbct model to predict the distribution
pred_mbct <- predict(mbct, data = new_obs, type = "response")
# Extract the predicted mean from the output and rescale to the original scale
pred_mean <- exp(pred_mbct)
# Print the predicted mean
print(pred_mean)


# Plot the predicted distribution
ggplot(data.frame(x = pred_mean), aes(x)) +
  geom_density(fill = "blue", alpha = 0.3) +
  labs(title = "Predicted Distribution for the First Out-of-Sample Observation",
       x = "Price")


#********************************************************************




