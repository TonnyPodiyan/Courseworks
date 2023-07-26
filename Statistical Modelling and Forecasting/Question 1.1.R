rm(list = ls()) # clears all objects in the workspace


#a
library(gamlss)
data(dbbmi)
old <- 15
da<- with(dbbmi, subset(dbbmi, age>old & age<old+1))
bmi15<-da$bmi
#write.csv(da, file = "my_data.csv")

library(MASS)

n_bins <- nclass.scott(bmi15)
truehist(bmi15, nbins=19, col="lightgray")


#b
mno<-gamlss(bmi15~age, data=da) # fit the model
mga <- gamlss(bmi15~age, data=da, family=GA)
mig <- gamlss(bmi15~age, data=da, family=IG)
mbccg <- gamlss(bmi15~age, data=da, family=BCCGo)
GAIC(mno, mga, mig, mbccg)

# plot fitted distribution 
plot(mno, which = 1, type = "l") 
plot(mga, which = 1, type = "l") 
plot(mig, which = 1, type = "l") 
plot(mbccg, which = 1, type = "l")

# mbccg has the lowest AIC value

#c
summary(mno)
summary(mga)
summary(mig)
summary(mbccg)    







