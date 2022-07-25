library(tuneR)
library(parallel)
library(audio)
library(xlsx)
library(elan)
library(xml2)
library(rPraat)
library(stringr)
library(tidyverse)

#======================================================================
#======================================================================
#Get the paths of the audio files
audio_files_ssds <- data.frame(file = list.files('/Users/u1037706/Dropbox/CoE_Sound-Files/SydSpks_1970s-Corpus', 
                                                 pattern = '.wav', full.names = T))
audio_files_syds_anglo <- data.frame(file = list.files('/Users/u1037706/Dropbox/CoE_Sound-Files/SydSpks_2010s-Corpus/Anglo', 
                                                       pattern = '.wav', full.names = T))
audio_files_syds_cantonese <- data.frame(file = list.files('/Users/u1037706/Dropbox/CoE_Sound-Files/SydSpks_2010s-Corpus/Cantonese', 
                                                       pattern = '.wav', full.names = T))
audio_files_syds_greek <- data.frame(file = list.files('/Users/u1037706/Dropbox/CoE_Sound-Files/SydSpks_2010s-Corpus/Greek', 
                                                           pattern = '.wav', full.names = T))
audio_files_syds_italian <- data.frame(file = list.files('/Users/u1037706/Dropbox/CoE_Sound-Files/SydSpks_2010s-Corpus/Italian', 
                                                       pattern = '.wav', full.names = T))
audio_files <- do.call("rbind", list(audio_files_ssds, audio_files_syds_anglo, audio_files_syds_cantonese, 
                                     audio_files_syds_greek, audio_files_syds_italian))

audio_files <- data.frame(file = list.files('./audio', 
                                            pattern = '.wav', full.names = T))
  
fileLength <- NULL

for(i in audio_files$file){
  print(i)
  
  s1 <-readWave(i, header=TRUE)
  sound_length <- round((round(s1$samples / s1$sample.rate, 2)),4)
  #sound_length <- round((round(length(s1@left) / s1@samp.rate, 2) / 60),4)
  
  fileLength <- append(fileLength, sound_length)
  
}

audio_files$dur <- fileLength
audio_files$name <- gsub('.wav', '', basename(as.character(audio_files$file)))

write.csv(audio_files, 'audio_files_new.csv', row.names = F)
#======================================================================
#======================================================================

fls

df <- read.csv('/Users/u1037706/Dropbox/CoE_Sound-Files Anonymised/AudioFiles/audiofilesDurs.csv')
df2 <- df[grep('^SSDS|^ssds', df$name),]
df <- df[!grepl('^SSDS|^ssds', df$name),]

df2$name = gsub('W_|U_|M_', '_', df2$name)

df <- rbind(df, df2)

df <- df %>% distinct(name, .keep_all = T)

fls <- list.files('/Users/u1037706/Dropbox/CoE_Sound-Files Anonymised/Elan/2020_anonymise LaBB-CAT', pattern = '.eaf', full.names = T)

flstmp <- gsub('\\.eaf', '', basename(fls))

flstmp <- flstmp[flstmp %in% df$name]
