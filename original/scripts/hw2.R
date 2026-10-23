# clear console
cat("\014")

rm(list=ls())

tw <- read.csv("C:/Users/user/Downloads/Bart/Datasets/hw1/tw.dat", sep="")
View(tw)

library(ggplot2)
library(pastecs)
library(QuantPsyc)
library(Hmisc)
library(car)
library(psych)
library(plyr)


# QUESTION 1
# a
ggplot(tw,aes(inspectability,understandability))+
  stat_summary(fun=mean,geom = "bar",fill="white",color="black")+
  stat_summary(fun.data = mean_cl_normal,geom = "errorbar",width=0.2)

#c
ggplot(tw,aes(inspectability,understandability))+
  stat_summary(fun=mean,geom = "bar",fill="white",color="black")+
  stat_summary(fun.data = mean_cl_normal,geom = "errorbar",width=0.2)+
  facet_wrap(~control)


#e
line <- ggplot(tw,aes(control,perceived_control))
line + stat_summary(fun.y = mean, geom = "point") + 
  stat_summary(fun.y = mean, geom = "line", aes(group=1), 
     color = "blue", linetype = "dashed") + 
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2)


#line + stat_summary(fun.y = mean, geom = "point") + stat_summary(fun.y =
#mean, geom = "line", aes(group = inspectability)) + stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2) + 
#labs(x = "Time", y = "Mean Grammar Score", colour = "inspectability")

#g
 line <- ggplot(tw, aes(x = control, y = perceived_control, color = inspectability))
    line + stat_summary(fun = mean, geom = "point") +
      stat_summary(fun = mean, geom = "line", aes(group = inspectability)) +
      stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.2) +
      labs(x = "Control", y = "Mean Perceived Control") 

#2
    
#a
sample_size <- table(tw$inspectability)
print(sample_size)
graphview  = 136
listview = 131


#b
by(tw$understandability, tw$inspectability, stat.desc, basic = F, norm = T)

varG <- 9.05
varL <- 12.49
d <- .33
difference <- d*(sqrt((varG + varL)/2))
print(difference)

#c
by(tw$understandability, tw$inspectability, stat.desc, basic = F, norm = T) 

ggplot(tw, aes(x = understandability, fill = inspectability)) +
  geom_histogram(position = "dodge", binwidth = 1, color = "black") +
  stat_function(fun = dnorm, args = list(mean = mean(tw$understandability), 
  sd = sd(tw$understandability)), 
  color = "red", size = 1) +
  labs(title = "Understandability by Inspectability",
  x = "Understandability", y = "Inspectability", fill = "Inspectability") +
  facet_wrap(~inspectability, ncol = 2)


#f
tw$inspectability <- factor(tw$inspectability, levels = c("graphview", "listview"))
levels(tw$inspectability)
t.test(understandability ~ inspectability, data = tw, alternative = "greater")


#g
WRS2::yuenbt(understandability ~ inspectability, data = tw, nboot = 10000, tr=0)
#h
WRS2::yuenbt(understandability ~ inspectability, data = tw, nboot = 10000)
#i
WRS2::pb2gen(understandability ~ inspectability, data = tw, boot = 10000) 

#k
tTest <- 3.7022
tTest_squared = tTest^2
df <- 255.09
r <- sqrt(tTest_squared/(tTest_squared+df))
r

var <- tTest_squared/(tTest_squared+df)
var

#l
pairwise.t.test(tw$perceived_control, tw$control, p.adjust.method = "bonferroni") 


#3
#a
by(tw$perceived_control, tw$control, stat.desc, basic = F, norm = T)

ggplot(tw, aes(x = perceived_control, fill = control)) +
  geom_histogram(position = "dodge", binwidth = 1, color = "black") +
  stat_function(fun = dnorm, args = list(mean = mean(tw$perceived_control), 
  sd = sd(tw$perceived_control)), 
  color = "red", size = 1) +
  labs(title = "Perceived control by control",
  x = "Perceived Control", y = "Control", fill = "Control") +
  facet_wrap(~control, scales = "free")

#c
ggplot(tw,aes(control,perceived_control))+geom_boxplot()
leveneTest(perceived_control ~ control, data = tw, center = mean)

perceivedControl <- var(tw$perceived_control)
friendControl <- var(tw$perceived_control[tw$control == "friend"])
itemControl <- var(tw$perceived_control[tw$control == "item"])
noneControl <- var(tw$perceived_control[tw$control == "none"])
largest_variance <- max(friendControl, itemControl, noneControl)
smallest_variance <- min(friendControl, itemControl, noneControl)
Fmax <- largest_variance / smallest_variance
Fmax

#d (CHECK)
none_v_any <- c(-1, 1/2, 1/2) 
item_v_friend <- c(0, -1, 1) 
contrasts_matrix <- cbind(none_v_any, item_v_friend)
contrasts(tw$control) <- contrasts_matrix
is.null(attr(contrasts(tw$control), "colnames"))
#----------------------------------------
none_v_any <- c(1/3,1/3,-2/3) 
item_v_friend <- c(0, 1/2, -1/2) 
contrasts_matrix <- cbind(none_v_any, item_v_friend)
contrasts(tw$control) <- contrasts_matrix
is.null(attr(contrasts(tw$control), "colnames"))

#e
modelAOV <- aov(perceived_control ~ control, data = tw) 
summary(modelAOV)

#f
modelLM <- lm(perceived_control ~ control, data = tw)
summary.lm(modelLM)

#g
oneway.test(perceived_control ~ control, data = tw) 

library(multcomp)

#h
post <- glht(modelAOV, linfct=mcp(control = "Tukey")) 
summary(post) 
confint(post)

#i
rSquared <- 36 / (36 + 3643)
r <- sqrt(rSquared)
r

omegaSquared <- (36 - 2 * 13.8) / (36 + 3643 + 2 * 13.8)
omegaVal <- sqrt(omegaSquared)
omegaVal

#j
contrast1 <- -0.4599 / sqrt((-0.4599)^2 + 2 * (0.3216)^2)
contrast1
contrast2 <- -0.1994 / sqrt((-0.1994)^2 + 2 * (0.2786)^2)
contrast2

#k
meanDiff <- -0.4599 + 0.1994
sdDiff <- sqrt((3.715^2 + 3.715^2) / 2)
d <- meanDiff / sdDiff
d

#l
#planned contrast
rnoneVany <- sqrt(.322^2/(.322^2+264))
ritemVfriend <- sqrt(.279^2/(.279^2+264))

#m
omega <- 0.048  
f <- sqrt(omega^2 / (1 - omega^2))


# QUESTION 4
#a
levels(tw$inspectability) <- c("listview", "graphview")
levels(tw$inspectability)
none_v_any <- c(-1, 1/2, 1/2) 
item_v_friend <- c(0, -1, 1)
tw$inspectability <- factor(tw$inspectability)
contrasts(tw$inspectability)<-c(-1/2, 1/2) 

#b
u1 <- aov(understandability ~ inspectability*control, data = tw)
Anova(u1, type=2) 

#d
WRS2::t2way(understandability ~ inspectability*control, data=tw, tr=0.2) 

#e
u2 <- aov(understandability ~ inspectability+control, data = tw)
Anova(u2, type=2)

#f
summary.lm(u2)

#g
tw$simple <- interaction(tw$control, tw$inspectability)

inspectability_graph <- c(-2/3,1/3,1/3,-2/3,1/3,1/3)
inspectability_list <- c(0, -1/2, 1/2, 0, -1/2, 1/2)
control_none <- c(-1/2, 0, 0, 1/2, 0, 0)
control_friend <- c(0, -1/2, 0, 0, 1/2, 0)
control_item <- c(0, 0, -1/2, 0, 0, 1/2)

contrasts(tw$simple) <- cbind(inspectability_graph, inspectability_list,
control_none, control_friend, control_item) 

simpleg <- aov(understandability ~ simple, data = tw)
summary.lm(simpleg)

#h
summary.lm(u2)
r_squared <- .08051
r <- sqrt(r_squared)
r

#i
omega_aov <- function(u2){
  MS<-summary(u2)[[1]]$'Mean Sq'; #get the mean squares
  df<-summary(u2)[[1]]$Df; #get the Dfs
  MSr<-MS[length(MS)]; #get MSr (the last one)
  N<-sum(df)+1; #get N (sum of df+1)
  MS<-MS[-c(length(MS))]; #remove MSr from MS
  df<-df[-c(length(df))]; #remove dfr from df
  var<-df*(MS-MSr)/N; #get the variances
  varTotal<-sum(var)+MSr; #get the total variance
  omega.squared<-var/varTotal; #get the omega-squareds
  omega<-sqrt(omega.squared); #get the omegas
  labels<-attr(u2$terms,"term.labels"); #get labels
  return(cbind(labels,omega,omega.squared))
}
omega_aov(u2)

#j
ωSquaredInspectability <- .0458
ωSquaredControl <- .02398
rInspectability <- sqrt(ωSquaredInspectability/(1 - ωSquaredInspectability))
rControl <- sqrt(ωSquaredControl/(1 - ωSquaredControl))
rInspectability
rControl

#k
library(compute.es)

desc <- by(tw$understandability, list(tw$inspectability,tw$control), stat.desc)
#mes(meanListview, meanGraphview, sdListview, sdGraphview, nListview, nGraphview)
mes(1.095317633, 2.581757467, 3.486709633, 2.985056867, 131, 136)

#l





