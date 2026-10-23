div <- read.csv("C:/Users/user/Downloads/Bart/Assignments/hw4/div.dat", sep="", stringsAsFactors=TRUE)
View(div)

# a
div$diversification <- factor(div$diversification, levels = c("low", "medium", "high"))
levels(div$diversification)

# b
library(ggplot2)
ggplot(div, aes(diversification, perceived_diversity)) + geom_boxplot()

# c
library(car)
leveneTest(div$perceived_diversity, div$diversification, level = mean)

# d
library(pastecs)
by(div$perceived_diversity, div$diversification, stat.desc, basic = F, norm = T)
divLow <- subset(div, diversification == "low", select = c("perceived_diversity"))
divMedium <- subset(div, diversification == "medium", select = c("perceived_diversity"))
divHigh <- subset(div, diversification == "high", select = c("perceived_diversity"))
shapiro.test(divLow$perceived_diversity)
shapiro.test(divMedium$perceived_diversity)
shapiro.test(divHigh$perceived_diversity)

hist_div <- ggplot(div, aes(perceived_diversity)) + geom_histogram(binwidth = 1,
 aes(y=..density..), color = "black", fill = "white")

hist_div + stat_function(fun=dnorm, args = list(mean=mean(div$perceived_diversity,
   na.rm=T), sd=sd(div$perceived_diversity, na.rm = T))) + facet_wrap(~diversification)

# e
library(ez)
ezAOV <- ezANOVA(data = div, dv=.(perceived_diversity), wid=.(userId), within=.(diversification),
 detailed = T, type = 3)

# g
pairwise.t.test(div$perceived_diversity, div$diversification, paired=T, p.adjust.method = "bonferroni")

# i
library(multcomp)
posthocs <- glht(div, linfct=mcp(diversification="Tukey"))
summary(posthocs)
confint(posthocs)

WRS2::rmanova((div$perceived_diversity, div$diversification, div$userId, tr=.2,nboot = 2000))

pairedepb((div$perceived_diversity, div$diversification, div$userId, tr=.2, nboot = 2000))

# j
library(nlme)
baseModel <- gls(perceived_diversity~1, data = div, method = "ML")

# k
randomModel <- lme(perceived_diversity~1, random =~1|userId, data = div, method = "ML")

# l
divModel <- lme(perceived_diversity ~ diversification, 
   random = ~ 1 | userId, data = div, method = "ML")


# m
anova(baseModel, randomModel, divModel)

# n
summary(divModel)

# 2
# a
div$length_factor <- factor(div$length, levels = c(5,10,15,20,25))

# b
ezAOV2 <- ezANOVA(data = div, dv =.(perceived_diversity), wid =.(userId), within =.(diversification),
    between =.(length_factor), detailed=T, type = 3)

# d
lengthModel <- update(divModel, .~. +length)

# e
intModel <- update(lengthModel, .~. +length:diversification)

# f
anova(divModel, lengthModel, intModel)

# g
summary(intModel)

# 3
# a
baseDiff <- gls(choice_difficulty~1, data=divLateset, method = "ML")

# b
randomDiff <- lme(choice_difficulty~1, random =~1|userID, data=divLateset, method = "ML")

#c
divDiff <- update(randomDiff, .~. +diversification)

#d
anova(baseDiff, randomDiff, .~. +diversification)

#e
summary(divDiff)

#g
fullDiff <- update(divDiff, .~. +perceived_diversity)

# h
anova(divDiff, fullDiff)

# i
summary(fullDiff)

# k
perceiveDiff <- update(randomDiff, .~. +perceived_diversity)

#l
anova(fullDiff, perceiveDiff)









