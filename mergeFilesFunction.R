#This script merges multiple individual files into a single file

fls <- list.files('./files/', pattern = '.csv', full.names = T)

df <- read.csv(fls[1])

for(i in fls[-1]){
  tmp_df <- read.csv(i)
  df <- rbind(df, tmp_df)
}

write.csv(df, 'df.csv', row.names = F, na = "")