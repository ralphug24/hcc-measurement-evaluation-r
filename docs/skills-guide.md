# Skills demonstrated through the assignments

This guide explains the learning progression in the four Spring 2024 assignments. It accompanies the original submissions and their saved R output.

## What I learned across the course

The assignments developed my ability to connect a user research question to a suitable analysis, work through that analysis in R and explain the evidence. The common thread was choosing and interpreting a method in light of the outcome, the study structure and its assumptions.

| Skill developed | Where I practiced it | What I take forward |
| --- | --- | --- |
| Match a method to a question | Homework 1 and 3: continuous, binary, count and categorical outcomes | Define the outcome and predictors before selecting a test or model |
| Compare interface conditions | Homework 2: t-tests, ANOVA, contrasts and interactions | Separate main effects, planned comparisons and interactions |
| Explain uncertainty and effect size | Homework 1 and 2: confidence intervals, estimates and effect sizes | Consider magnitude and precision alongside statistical evidence |
| Check model assumptions | Homework 1: residuals, influence diagnostics, collinearity and bootstrap exercises | Investigate whether a result depends on problematic observations or assumptions |
| Account for repeated observations | Homework 4: repeated-measures methods and random intercepts | Distinguish observations from independent participants |
| Communicate an interpretable conclusion | All four assignments: written explanations alongside saved outputs | Explain a coefficient on the right scale and connect it to the research question |

## How I can apply this to user research and interface evaluation

- **Plan a comparison:** identify the interface conditions, outcome measures and whether each participant experiences one condition or several.
- **Choose the analysis deliberately:** a rating, binary success indicator and count each call for different modeling considerations. Repeated responses require attention to participant grouping.
- **Inspect the evidence:** look at distributions, estimates, uncertainty and model diagnostics before summarizing the result.
- **Communicate a decision input:** explain the size and precision of a difference, what the study supports and what further evidence would help a team choose a direction.
- **Make the analysis inspectable:** retain commands, outputs and interpretations together so collaborators can follow how the conclusion was reached.

These are applications of the skills developed through supplied-data exercises. The coursework does not establish that I recruited these participants or built the interfaces under study. The saved original reports and scripts remain the evidence of the assignments; this guide explains the methods and their interpretation.

## Homework 1: describe data and build an explanatory model

**Evaluation question:** how are recommendation quality, perceived control and understandability associated with satisfaction?

The work included summary statistics, confidence intervals, histograms, correlation, multiple regression, nested-model comparisons, standardized residuals, influence diagnostics, variance inflation factors and bootstrap estimates.

The saved model comparison reports R-squared values of 0.3556, 0.5185 and 0.5228 as predictors are added. The useful skill is deciding whether extra model complexity adds information, while checking the fitted model's assumptions and influential observations.

```r
model1 <- lm(satisfaction ~ quality, data = tw)
model2 <- lm(satisfaction ~ quality + perceived_control + understandability,
             data = tw)
summary(model2)
anova(model1, model2)
```

In the saved three-predictor summary, quality and perceived control have positive coefficients with small p-values. Understandability's p-value is 0.144 when the other two predictors are included. The model describes conditional associations in the analyzed data. Its R-squared is not an estimate of performance on new observations.

## Homework 2: compare conditions and separate main effects from interactions

**Evaluation question:** how do interface inspectability and control conditions relate to understandability and perceived control?

The work included confidence-interval plots, a Welch two-sample t-test, effect-size calculations, robust alternatives, ANOVA, planned contrasts, post-hoc comparisons and factorial analysis.

```r
tw$inspectability <- factor(tw$inspectability,
                            levels = c("graphview", "listview"))
t.test(understandability ~ inspectability, data = tw,
       alternative = "greater")

u1 <- aov(understandability ~ inspectability * control, data = tw)
car::Anova(u1, type = 2)
```

The saved Welch output reports means of about 2.574 for graph view and 1.084 for list view, with a one-sided p-value of 0.000131. Its one-sided 95% confidence interval has a lower bound of about 0.825 and an infinite upper bound. A two-sided interval answers a different inferential question.

The factorial ANOVA output gives main-effect p-values of approximately 0.000222 for inspectability and 0.0130 for control, and an interaction p-value of 0.832. A visual pattern or overlapping error bars alone does not establish a statistically supported interaction.

## Homework 3: match the model family to the outcome

**Evaluation question:** how does music expertise relate to recognizing recommendations, and how are privacy-awareness and behavior categories associated?

The work included a binary target, binomial logistic regression, likelihood/deviance comparisons, exponentiated coefficients, predicted probabilities, count regression and categorical analysis.

```r
allknown <- tw$known == 10
allknown_reg <- glm(allknown ~ expertise, data = tw, family = binomial)
summary(allknown_reg)
exp(coef(allknown_reg))

tw$dontknow <- 10 - tw$known
count_model <- glm(dontknow ~ expertise + inspectability,
                   data = tw, family = quasipoisson())

mosaicplot(table(privacy), shade = TRUE)
```

The saved logistic summary has an expertise coefficient of about 0.1254, corresponding to an odds ratio of about 1.134. The distinction matters: a 13.4% increase in odds is not a 13.4 percentage-point increase in probability.

The count exercise uses a quasi-Poisson family, which estimates a dispersion parameter. A quasi-likelihood model should not be treated as having the same likelihood or model-comparison quantities as an ordinary Poisson model. For categorical analysis, expected cell counts and the choice of association test need attention before interpreting a mosaic plot.

## Homework 4: account for repeated observations

**Evaluation question:** how do diversification and list length relate to perceived diversity and choice difficulty when the same person provides several responses?

The work included repeated-measures ANOVA, mixed ANOVA, a participant-level random intercept, nested mixed-model comparisons and a mediation exercise.

```r
randomModel <- nlme::lme(perceived_diversity ~ 1,
                         random = ~ 1 | userId, data = div, method = "ML")
divModel <- nlme::lme(perceived_diversity ~ diversification,
                      random = ~ 1 | userId, data = div, method = "ML")
anova(randomModel, divModel)
summary(divModel)
```

The saved summary has 291 observations from 97 users. Medium and high diversification have positive coefficients relative to low diversification in that model. The grouping structure matters because three responses from one person should not be treated as three independent participants.

Sphericity concerns variances of within-person differences; it is distinct from equal marginal group variances. A nonsignificant Mauchly test does not prove sphericity, but does not provide evidence against it. The mediation exercise practices a sequence of model comparisons; causal mediation would require additional assumptions and an explicit assessment of the indirect effect.

## Applying these skills

The coursework helped me practice a consistent evaluation workflow: define the outcome and study structure, inspect the data, choose an appropriate method, compare models or conditions, review assumptions, and explain both the result and its limits.
