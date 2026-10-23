# clear console
cat("\014")

tw <- read.csv("C:/Users/user/Downloads/Bart/Datasets/hw1/tw.dat", sep="", stringsAsFactors=TRUE)
View(tw)

# Question 1
# a
allknown <- tw$known == 10

allknown_reg1 <- glm(allknown ~ expertise, data = tw, family = binomial)
summary(allknown_reg1)


# b
allknown_reg0 <- glm(allknown ~ 1, data = tw, family = binomial)
anova(allknown_reg0,allknown_reg1)

# c
# probability of knowing all recommendations at expertise = 0
1/(1+exp(-(-1.0529 + 0.1254 * 0)))

# probability of knowing all recommendations at expertise = 4
1/(1+exp(-(-1.0529 + 0.1254 * 4)))

# d
exp(allknown_reg1$coefficients)
X <- 1.1336179
percentage <- (X - 1) * 100

# e
exp(confint(allknown_reg1))

# f
# Difference in deviances <- Null deviance − Residual deviance
allknown_reg0 <- glm(allknown ~ 1, data = tw, family = binomial)
anova(allknown_reg0,allknown_reg1)

# -2 Log Likelihood (-2LL)
ratio <- allknown_reg1$null.deviance - allknown_reg1$deviance

df <- allknown_reg1$df.null - allknown_reg1$df.residual

# True p-value
1 - pchisq(ratio, df)

# Hosmer and Lemeshow Rsquared
ratio/allknown_reg1$null.deviance

# Cox and Snell Rsquared
1 - exp(-ratio/267)

# Nagelkerke Rsquared
(1 - exp(-ratio/267))/(1-exp(-allknown_reg1$null.deviance/267))

# i
tw$inspectability <- as.factor(tw$inspectability)
allknown_reg2 <- glm(allknown ~ expertise + inspectability, data = tw, family = binomial)
summary(allknown_reg2)

# j
anova(allknown_reg1, allknown_reg2)
1 - pchisq(allknown_reg1$deviance - allknown_reg2$deviance, 
    allknown_reg1$df.residual - allknown_reg2$df.residual)

exp(allknown_reg2$coefficients)

#k
exp(confint(allknown_reg2))

#l
ratio2 <- allknown_reg1$deviance - allknown_reg2$deviance

df2 <- allknown_reg1$df.residual - allknown_reg2$df.residual

# True p-value
1 - pchisq(ratio2, df2)

# m
# Cox and Snell Rsquared
1 - exp(-ratio2/267)

# Nagelkerke Rsquared
(1 - exp(-ratio2/267))/(1-exp(-allknown_reg1$deviance/267))

# R squared
anova(allknown_reg0,allknown_reg1)
anova(allknown_reg1,allknown_reg2)

chisq1 <- 6.531
df1 <- 1
null_dev1 <- 356.99
dev1 <- 350.48

# Hosmer and Lemeshow Rsquared
(null_dev1 - dev1) / null_dev1

# Cox and Snell Rsquared
1 - exp(-(null_dev1 - dev1)/267)

# Nagelkerke Rsquared
(1 - exp(-(null_dev1 - dev1)/267)) / (1 - exp(-(null_dev1)/267))


chisq2 <- 2.716
df2 <- 1
null_dev2 <- 350.48
dev2 <- 347.77

# Hosmer and Lemeshow Rsquared
(null_dev2 - dev2) / null_dev2

# Cox and Snell Rsquared
1 - exp(-(null_dev2 - dev2)/267)

# Nagelkerke Rsquared
(1 - exp(-(null_dev2 - dev2)/267)) / (1 - exp(-(null_dev2)/267))


# Question 2
# a
tw$dontknow <- 10 - tw$known

# b
ggplot(tw, aes(dontknow)) + geom_histogram(aes(y=..density..),
binwidth=1, color="black", fill="white") + stat_function(fun = dnorm,
args = list(mean = mean(tw$dontknow), sd = sd(tw$dontknow)))

# c
lm_dontknow <- lm(dontknow ~ expertise + inspectability, data = tw)
summary(lm_dontknow)

# e
tw$lmresid <- rstandard(lm_dontknow)
tw$lmresid.large <- (tw$lmresid > 1.96 | tw$lmresid < -1.96)
tw[tw$lmresid.large,]  
plot(lm_dontknow)
lm_dontknow$cook <- cooks.distance(lm_dontknow)
tw[tw$lmresid.large,c("cook")] 


# f
lmp_dontknow <- glm(dontknow ~ expertise + inspectability, data = tw, family = quasipoisson())
summary(lmp_dontknow)

# g
# Hosmer and Lemeshow Rsquared
(lmp_dontknow$null.deviance - lmp_dontknow$deviance) / lmp_dontknow$null.deviance
  
# Cox and Snell Rsquared
1 - exp(-lmp_dontknow$null.deviance - lmp_dontknow$deviance/267)

# Nagelkerke Rsquared
(1 - exp(-lmp_dontknow$null.deviance - lmp_dontknow$deviance/267))/(1-exp(-lmp_dontknow$null.deviance/267))

# g & h
exp(lmp_dontknow$coefficients)

# i
exp(confint(lmp_dontknow))

# j
ratio3 <- lmp_dontknow$null.deviance - lmp_dontknow$deviance

df3 <- lmp_dontknow$df.null - lmp_dontknow$df.residual

# True p-value
1 - pchisq(ratio3, df3)

# Hosmer and Lemeshow Rsquared
ratio3/lmp_dontknow$null.deviance

# Cox and Snell Rsquared
1 - exp(-ratio3/267)

# Nagelkerke Rsquared
(1 - exp(-ratio3/267))/(1-exp(-lmp_dontknow$null.deviance/267))

# k
tw$lmresidP <- rstandard(lmp_dontknow)
tw$lmresidP.large <- (tw$lmresidP > 1.96 | tw$lmresidP < -1.96)
tw[tw$lmresidP.large,]  
plot(lmp_dontknow)


# Question 3
privacy <- read.csv("C:/Users/user/Downloads/Bart/Assignments/hw3/privacy.csv", stringsAsFactors=TRUE)
View(privacy)

# a
mosaicplot(table(privacy), shade = T)

# c
library(gmodels)
CrossTable(table(privacy), expected = T, sresid = T, format = "SPSS")


Odds_Max_Min_Experts <- 13/5
Odds_others <- (1 + 11 + 1 + 3 + 1) / (21 + 10 + 19 + 3 + 10)
odds_ratio <- Odds_Max_Min_Experts / Odds_others


