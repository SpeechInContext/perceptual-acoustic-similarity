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

dist.files <- c('segmental_duration.txt','ampenv_dct.txt','ampenv_dct_vowel.txt','ampenv_dtw.txt','ampenv_dtw_vowel.txt', 'ampenv_midpoint.txt','ampenv_third.txt', 'ampenv_xcorr.txt','ampenv_xcorr_vowel.txt','formants_praat_dct.txt','formants_praat_dct_vowel.txt','formants_praat_dtw.txt','formants_praat_dtw_vowel.txt','formants_praat_midpoint.txt','formants_praat_third.txt','formants_praat_xcorr.txt','formants_praat_xcorr_vowel.txt','intensity_praat_dct.txt','intensity_praat_dct_vowel.txt','intensity_praat_dtw.txt','intensity_praat_dtw_vowel.txt','intensity_praat_midpoint.txt','intensity_praat_third.txt','intensity_praat_xcorr.txt','intensity_praat_xcorr_vowel.txt','mfcc_dct.txt','mfcc_dct_vowel.txt','mfcc_dtw.txt','mfcc_dtw_vowel.txt','mfcc_midpoint.txt','mfcc_praat_dct.txt','mfcc_third.txt','mfcc_xcorr.txt','mfcc_xcorr_vowel.txt','mfcc_praat_dct.txt','mfcc_praat_dct_vowel.txt','mfcc_praat_dtw.txt','mfcc_praat_dtw_vowel.txt','mfcc_praat_midpoint.txt','mfcc_praat_third.txt','mfcc_praat_xcorr.txt','mfcc_praat_xcorr_vowel.txt','pitch_praat_dct.txt','pitch_praat_dct_vowel.txt','pitch_praat_dtw.txt','pitch_praat_dtw_vowel.txt','pitch_praat_midpoint.txt','pitch_praat_third.txt',
                'mfcc20_dct.txt','mfcc20_dct_vowel.txt','mfcc20_dtw.txt','mfcc20_dtw_vowel.txt','mfcc20_midpoint.txt','mfcc20_third.txt','mfcc20_xcorr.txt','mfcc20_xcorr_vowel.txt',
                'mfcc20Power_dct.txt','mfcc20Power_dct_vowel.txt','mfcc20Power_dtw.txt','mfcc20Power_dtw_vowel.txt','mfcc20Power_midpoint.txt','mfcc20Power_third.txt','mfcc20Power_xcorr.txt','mfcc20Power_xcorr_vowel.txt',
                'mfccPower_dct.txt','mfccPower_dct_vowel.txt','mfccPower_dtw.txt','mfccPower_dtw_vowel.txt','mfccPower_midpoint.txt','mfccPower_third.txt','mfccPower_xcorr.txt','mfccPower_xcorr_vowel.txt',
                'pitch_praat_xcorr.txt','pitch_praat_xcorr_vowel.txt')

#models = list()

for (di in 1:length(dist.files)){
  cat(di,'\n')
  name = dist.files[di]
  cat(name,'\n')
  if (di <= length(models)){
    next
  }
  n = str_replace(name,'.txt','')
  if (!n %in% c('pitch_praat_xcorr_vowel', 'pitch_praat_xcorr')){
    dist = read.delim(name)
    dist$Shadower <- factor(dist$Shadower)
    dist$Model <- factor(dist$Model)
    dist$BaseToModel <- as.numeric(as.character(dist$BaseToModel))
    dist$ShadToModel <- as.numeric(as.character(dist$ShadToModel))
    
    colname <- paste(n,'_difference',collapse='',sep='')
    
    dist[,c(colname)]<- durdist$BaseToModel - dist$ShadToModel
    print(summary(dist))
    
    axb <- merge(axb, dist[,c('Shadower','Model','Word',colname)])
    axb$Difference <- axb[,c(colname)]
    axb$Difference <- scale(axb$Difference)
    
    mod = glmer(Dependent ~ Difference + (1+Difference|Model) + (1+Difference|Shadower) + (1+Difference|Listener) + (1+Difference|Word),data = axb, family = 'binomial')
    
    models[[di]] = mod
  }
  
}
