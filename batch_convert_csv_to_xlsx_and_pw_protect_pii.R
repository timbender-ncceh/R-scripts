# script useful for batch converting a directory of csv files to xlsx and then
# password-protecting a specific file with pii when it's necessary to share the
# data via email or other electronic means

library(dplyr)
library(openxlsx)
library(xlsx)
library(readr)


rm(list=ls());cat('\f');gc()

# Vars----
proj.dir <- "C:/Users/TimBender/Documents/R/ncceh/encrypt_via_excel"
data.dir <- "C:/Users/TimBender/Documents/R/ncceh/encrypt_via_excel/data_goes_here"

# Set working directory
setwd(proj.dir)

# import all hmis docs----
setwd(data.dir)

csv.filenames <- list.files(pattern = "\\.csv$") %>%
  .[!. %in% "Client.csv"]

# read csv files to an empty list
csv.list <- list()
for(i in csv.filenames){
  csv.list[[i]] <- read_csv(i)
}

# write as excel files
for(i in names(csv.list)){
  temp.filename <- i %>%
    gsub(pattern = "csv$", replacement = "xlsx", x = .)
  openxlsx::write.xlsx(x = csv.list[[i]],  file = temp.filename)
  rm(temp.filename)
}

# Password protect client.xlsx
temp.pw <- sample(c(letters,LETTERS, 0:9), size = 24) %>% 
  paste(., sep = "", collapse = "")

# write the password to file
write_csv(data.frame(pw = temp.pw),"temppw.csv")

# write the password protected xlsx file to file
xlsx::write.xlsx(x = read_csv("Client.csv"), 
                 file = "Client.xlsx", 
                 password = temp.pw)

rm(temp.pw)

# delete hmis csv files
for(i in names(csv.list)){
  file.remove(i)
}
file.remove("Client.csv")

# zip up the xlsx files

library(zip)

# add zip compression in the future VVV
