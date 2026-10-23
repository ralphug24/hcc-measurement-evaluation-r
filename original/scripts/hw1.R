# clear console
cat("\014")

tw <- read.csv("C:/Users/user/Downloads/Bart/hw1/tw.dat", sep="")
View(tw)

# create a table
# tasteWeight <- read.table("C:/Users/user/Desktop/R Files/tw.dat", header = TRUE, sep = " ")
library(ggplot2)
tasteWeight <- ggplot(tw,aes(rating, quality))
tasteWeight + geom_point()

tasteWeight + stat_function(fun = dnorm, args = 
                              list(mean=mean(tw$rating, na.rm=T),sd = sd(tw$rating, na.rm=T)))

# confidence level of the "rating" variable
# step 1: calculate the mean
# step 2: Calculate the standard error of the mean
# step 3: Find the t-score that corresponds to the confidence level
# step 4: Calculate the margin of error and construct the confidence interval
# Standard error = standard deviation / √(sample size)
 
# QUESTION 1
# mean of the "rating" variable.

library(pastecs)
round(stat.desc(tw$rating, basic = F, norm = T), digits = 3)

mean <- 3.267
Std <- 0.730
SE <- Std/sqrt(267)
upper <- mean + 1.96*SE 
lower <- mean - 1.96*SE
show(upper)
show(lower)


# QUESTION 2
ggplot(tw,aes(rating)) + geom_histogram(aes(y = ..density..),
    color="black", fill="white") + stat_function(fun = dnorm, args=list(mean = mean(tw$rating), 
      sd = sd(tw$rating)))

library(pastecs)
round(stat.desc(tw$rating, basic = F, norm = T), digits = 3)
shapiro.test(tw$rating)


# 2b
ggplot(tw,aes(quality)) + geom_histogram(aes(y = ..density..),
    color="black", fill="white") + stat_function(fun = dnorm, args=list(mean = mean(tw$quality), 
       sd = sd(tw$quality)))

round(stat.desc(tw$quality, basic = F, norm = T), digits = 3)
shapiro.test(tw$quality)

# f
ggplot(tw, aes(quality, rating)) + geom_point() + geom_smooth(method = "lm", se = FALSE)

cor.test(tw$quality, tw$rating, method = "spearman")
cor.test(tw$quality, tw$rating, method = "spearman")^2

cor(tw$quality, tw$rating)^2

# QUESTION 3
model1 <- lm(satisfaction ~ quality, data = tw)
summary(model1)

library(QuantPsyc)
lm.beta(model1)
sqrt(0.3556)

model2 <- lm(satisfaction ~ quality + perceived_control + understandability, data = tw)
summary(model2)
lm.beta(model2)

anova(model1, model2)

library(Hmisc)
cor.test()
----------------
cor(tw[,c("satisfaction","rating","known","time")])
cor(tw[,c("rating","known","time")])
rcorr(as.matrix(tw[,c("rating","known","time")]))
rcorr(as.matrix(tw[,c("satisfaction","perceived_control","understandability","rating","known","time")]))

model3 <- lm(satisfaction ~ quality + perceived_control + understandability + rating + known, data = tw)
summary(model3)
lm.beta(model3)

anova(model3, model2)

library(car)
vif(model3)

ggplot(tw,aes(satisfaction)) + geom_histogram(aes(y = ..density..),
  color="black", fill="white") + stat_function(fun = dnorm, args=list(mean = mean(tw$satisfaction), 
    sd = sd(tw$satisfaction))) 

round(stat.desc(tw$satisfaction, basic = F, norm = T), digits = 3)
shapiro.test(tw$satisfaction)

tw$rstand <- rstandard(model2)
tw$rstand.large <- (tw$rstand > 1.96 | tw$rstand < -1.96)
tw[tw$rstand.large,c("quality", "perceived_control", "understandability","rstand")]

tw$cook <-cooks.distance(model2)
tw$leverage <- hatvalues(model2) 
tw$covratio <- covratio(model2)
tw[tw$rstand.large,c("cook", "leverage", "covratio")] 

library(car)
vif(model2)

plot(model2)

bootSatisfaction <- function(samples, i){ 
  fit <-lm(satisfaction ~ quality + perceived_control + understandability, data=tw[i,]) 
  return(coef(fit)) 
}
bootResults <- boot(tw, bootSatisfaction, 2000) 
bootResults

boot.ci(bootResults, type="bca", index=2)

tw$inspectability <- factor(tw$inspectability)
levels(tw$inspectability)
graph_v_list <- c(1,0)
contrasts(tw$inspectability) <- cbind(graph_v_list)

dummyModel <- lm(understandability ~ inspectability, data=tw) 
summary(dummyModel)


ggplot(tw,aes(inspectability,understandability))+geom_boxplot()

library(car)
leveneTest(dummyModel)
var.test(dummyModel, model2)

tw$control <- factor(tw$control)
levels(tw$control)
item_v_none <- c(1, 0, 0)
friend_v_none <- c(0, 1, 0)
contrasts(tw$control) <- cbind(item_v_none, friend_v_none)

controlModel <- lm(perceived_control ~ control, data=tw) 
summary(controlModel)

con_mat <- matrix(c(1/3, 1/3, 1/3, 0, 1, -1), ncol=3)
orth_mat <- solve(t(con_mat))
contr<-orth-mat[,2:]
contrasts(df$tw) = contr


