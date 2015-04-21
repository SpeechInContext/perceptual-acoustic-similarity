library(lme4)
library(ggplot2)
library(plyr)
library(stringr)

axb <- read.delim('axb.txt')

#File names use old ATI naming scheme
axb$ModelFile <- NULL
axb$BaselineFile <- NULL
axb$ShadowedFile <- NULL
axb$Shadower <- factor(str_replace(axb$Shadower, 'Subject',''))
axb$Model <- factor(str_replace(axb$Model, 'subj',''))
axb$Listener <- factor(axb$Listener)
summary(axb)

durdist = read.delim('segmental_duration.txt')
durdist$Shadower <- factor(durdist$Shadower)
durdist$Model <- factor(durdist$Model)
durdist$BaseToModel <- as.numeric(as.character(durdist$BaseToModel))
durdist$ShadToModel <- as.numeric(as.character(durdist$ShadToModel))

durdist$Difference <- durdist$BaseToModel - durdist$ShadToModel

axb <- merge(axb, durdist[,c('Shadower','Model','Word','Difference')])

mod = glmer(Dependent ~ Difference + (1+Difference|Model) + (1+Difference|Shadower) + (1+Difference|Listener) + (1+Difference|Word),data = axb, family = 'binomial')
summary(mod)
