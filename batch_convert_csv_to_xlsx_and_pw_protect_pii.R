# script useful for batch converting a directory of csv files to xlsx and then
# password-protecting a specific file with pii when it's necessary to share the
# data via email or other electronic means


# Github and Local File Info:----
# GITHUB URL: https://github.com/timbender-ncceh/R-scripts/blob/main/batch_convert_csv_to_xlsx_and_pw_protect_pii.R
# Local Filename: C:/Users/TimBender/Documents/R/ncceh/encrypt_via_excel/encrypt_via_excel.R


# Libraries----
library(dplyr)
library(openxlsx)
library(xlsx)
library(readr)
library(zip)
library(glue)

rm(list=ls());cat('\f');gc()

# Vars----
proj.dir <- "C:/Users/TimBender/Documents/R/ncceh/encrypt_via_excel"
data.dir <- "C:/Users/TimBender/Documents/R/ncceh/encrypt_via_excel/data_goes_here"

# Set working directory
setwd(proj.dir) # project directory is where .R script is saved as well as where the /data_goes_here subdirectory exists

# import all hmis docs----
setwd(data.dir) # data directory is where the .csv input files need to be dumped, and .xlsx output files will be saved
csv.filenames <- list.files(pattern = "\\.csv$") #%>% .[!. %in% "Client.csv"]

# check if there are any files other than hmis_csv files
non_hmis.files <- list.files()[!list.files() %in% csv.filenames |   # checks for files with extensions other than .csv
                                 list.files() %in% c("temppw.csv")] # checks specifically for password save files from old projects

# if there are any non-hmis_csv files...
if(length(non_hmis.files) > 0){
  #delete the non_hmis.files files because they are from previous projects: 
  if(getwd() == data.dir) file.remove(non_hmis.files)
  # repeat the directory scan for .csv files to update the 'csv.filenames' variable
  csv.filenames <- list.files(pattern = "\\.csv$") #%>% .[!. %in% "Client.csv"]
  # variable cleanup
  rm(non_hmis.files)
}else{
  rm(non_hmis.files)
}

# read csv files to an empty list
csv.list <- list()
for(i in csv.filenames){
  csv.list[[i]] <- read_csv(i)
}

# capture data from "Export.csv" to use for naming output files
zip.sd <- strftime(csv.list[["Export.csv"]]$ExportStartDate, 
         format = "%b%Y")
zip.ed <- strftime(csv.list[["Export.csv"]]$ExportEndDate, 
         format = "%b%Y")
zip.pn <- unique(csv.list[["Project.csv"]]$ProjectName)
if(length(zip.pn) == 1 & any(nchar(zip.pn) > 0)){
  zip.pn <- zip.pn %>%
    strsplit(., split = "-") %>%
    unlist() %>%
    trimws()
  
  zip.pn <- zip.pn[!(toupper(zip.pn) == zip.pn & 
    nchar(zip.pn) == 2)] %>%
    paste(., sep = "_", collapse = "_") %>%
    gsub(" ", "", .)

  
}else{
  zip.pn <- "ncceh_custom_report"
}

if(!(length(zip.pn) == 1 & any(nchar(zip.pn) > 0))){
  zip.pn <- "ncceh_custom_report"
}

zip.filename <- glue("hmiscsv_{zip.pn}_{zip.sd}to{zip.ed}.zip")
rm(zip.pn, zip.sd, zip.ed)

# write as excel files
for(i in names(csv.list)){
  
  # if i == 'Client.csv' we need to do the following:
  if(i == "Client.csv"){
    # 1) generate a secure password and set it to a temporary variable, 
    temp.pw <- sample(c(letters,LETTERS, 0:9), size = 24) %>% 
      paste(., sep = "", collapse = "")
    # 2) write 'Client.csv' to a password-protected .xlsx file using the password
    xlsx::write.xlsx(x = read_csv("Client.csv"), 
                     file = "Client.xlsx", 
                     password = temp.pw)
    # 3) write the generated password to a separate .csv file so that it can be shared with the recipient
    write_csv(data.frame(pw = temp.pw),"temppw.csv")
    # 4) remove the temporary password from memory
    rm(temp.pw)
    # 5) delete Client.csv now that it has been written to .xlsx and is no longer needed:
    if(getwd() == data.dir) file.remove(i)
  }else{
    # else if 'i' isn't 'Client.csv': 
    # 1) change file extension of 'i' from '.csv' to '.xlsx' and set as variable:
    temp.filename <- i %>%
      gsub(pattern = "csv$", replacement = "xlsx", x = .)
    # write i to new .xlsx file named [temp.filename]
    openxlsx::write.xlsx(x = csv.list[[i]],  file = temp.filename)
    # delete .csv file now that it has been written to .xlsx as is no longer needed:
    if(getwd() == data.dir) file.remove(i)
    # cleanup:
    rm(temp.filename)
  }
}

# zip up the xlsx files----

xlsx.filenames <- csv.filenames %>%
  gsub(pattern = "csv$", replacement = "xlsx", 
       x = .)

zip::zip(zipfile = zip.filename, 
         files = xlsx.filenames)

# cleanup uncompressed .xlsx files
if(getwd() == data.dir) file.remove(xlsx.filenames)

# cleanup and wipe all vars
rm(csv.list, csv.filenames, data.dir, i, proj.dir, xlsx.filenames, zip.filename)
