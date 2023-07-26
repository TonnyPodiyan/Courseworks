rm(list = ls()) # clears all objects in the workspace


#a
data(grip)

#b
set.seed(1088)
index<-sample(3766, 1000)
mydata<-grip[index, ]
dim(mydata)
#data <- unlist(mydata)

#c
library(ggplot2)

ggplot(data = mydata, aes(x = age, y = grip)) + 
  geom_point() + 
  labs(x = "Age", y = "Grip strength")

#d
gbccg <- gamlss(grip ~ pb(age), sigma.fo = ~pb(age), nu.fo = ~pb(age), data = mydata, family = BCCG)
edf(gbccg)

#e
gbct <- gamlss(grip ~ pb(age), sigma.fo = ~pb(age), nu.fo = ~pb(age), tau.fo = ~pb(age), data = mydata, family = BCT, start.from = gbccg)
gbcp <- gamlss(grip ~ pb(age), sigma.fo = ~pb(age), nu.fo = ~pb(age), tau.fo = ~pb(age), data = mydata, family = BCPE, start.from = gbccg)
edf(gbct)
edf(gbcp)

#f
# Calculate GAIC for each model
gaic_bccg <- GAIC(gbccg)
gaic_bct <- GAIC(gbct)
gaic_bcpe <- GAIC(gbcp)

# Print GAIC values
cat("GAIC for BCCG model:", gaic_bccg, "\n")
cat("GAIC for BCT model:", gaic_bct, "\n")
cat("GAIC for BCPE model:", gaic_bcpe, "\n")


#g
fittedPlot(gbct, x=mydata$age)
fittedPlot(gbcp, x=mydata$age)
fittedPlot(gbccg, x=mydata$age)
fittedPlot(gbcp ,gbct, gbccg, x=mydata$age)



#h
# Centile plots
cent_bccg <- centiles.split(gbccg)
cent_bct <- centiles.split(gbct)
cent_bcpe <- centiles.split(gbcp)

library(ggplot2)

# Residual plots
plot(gbccg)
wp(gbccg)
Q.stats(gbccg)

plot(gbct)
wp(gbct)
Q.stats(gbct)

plot(gbcp)
wp(gbcp)
Q.stats(gbcp)

# Obtain summary statistics for quantile residuals for gbccg
summary(gbccg, type = "qr")

# Obtain summary statistics for quantile residuals for gbct
summary(gbct, type = "qr")

# Obtain summary statistics for quantile residuals for gbcp
summary(gbcp, type = "qr")





