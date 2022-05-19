####################################
#####.........README...........#####
####################################
#---- Purpose of this Script
#       * Simple, rapid, no-cost geocoding of mailing addresses stored in a 
#         spreadsheet

#---- Installing R (https://cran.r-project.org/)
#       * This tool runs in the R environment, and thus needs to be installed 
#         on your machine.
#       * Install the most recent version based on your operating system: 
#         - Windows:  https://cran.r-project.org/bin/windows/base/
#         - MacOS:    https://cran.r-project.org/bin/macosx/
#         - Linux:    'sudo apt install r-base'

#---- To Use the tool
#       1) create a new folder, preferably on your C:/ drive (code not tested on 
#           network drives yet, YMMV)
#       2) paste a copy of the "geocoding.R" file into your new folder. 
#       3) place a copy of the spreadsheet "batch_addresses_in.xlsx" in the new folder
#           - This spreadsheet can only have 1 sheet of data (i.e. "Sheet1")
#           - This spreadsheet must have 4 columns labeled exactly as follows: 
#               1. street_address (always required)
#               2. city           (2 of 3 required)
#               3. state          (2 of 3 required)
#               4. zipcode        (2 of 3 required)
#       * point-and-click script file
#       * script will generate a .csv file named "batched_addressed_out.csv" 
#         with longitude / latitude coordinates as well as a report on the 
#         quality of the guess of the geocode (i.e. "exact", "close", "poor", etc.)


#---- Support
#       If you have followed these directions but the tool does not function as 
#       you believe it should , please contact Tim Bender at tim.bender@ncceh.org.
#       Include a description of the problem, and a copy of your .xlsx file in 
#       the email and I'll try to help.  
####################################
#####......../README...........#####
####################################

rm(list=ls());cat("\f")
# Libraries----
load.libs <- c("dplyr","censusxy","tidycensus","tigris","readxl","readr","rstudioapi")

# check if libraries/packages are installed
for(l in load.libs){
  # Is package 'l' installed? If not, ask user for permission to install package
  my.pkgs <- packageStatus()$inst$Package # gets a list of all installed packages
  if(!l %in% my.pkgs){
    cat('\n')
    # if run outside an interactive session, automatically install missing packages
    permit.install.pkg <- ifelse(interactive(), readline(prompt = paste("Authorize Script to install package [",l,"] (y/n)?", sep = "")), "y")
    # If authorized, install package
    ifelse(test = tolower(permit.install.pkg) %in% c("y", "yes"), 
           install.packages(l), 
           print("User declined installation of required package; script will not execute properly until installation is permitted. If you receive this message in error contact Tim Bender"))
  }else{
    cat('\n')
    print(paste(l,"already installed"))
  }
  # now that library has been installed if missing, load library
  library(l, character.only = T)
  print(paste(l,"loaded"))
}

# set working directory----
# get filename of script
script.filename <- getActiveDocumentContext()$path %>%  
  strsplit(x = ., 
           split = "/") %>%
  unlist() %>%
  last()
# get directory where script is saved
script.dir <- rstudioapi::getActiveDocumentContext()$path %>% 
  gsub(pattern = script.filename, 
       replacement = "", 
       x = .)
# set working directory to where script is saved, so that as long as
# spreadsheet is placed in same directory as script, script will find that file
# and process it
setwd(script.dir)

# batch geocode from spreadsheet----
if(file.exists("batch_addresses_in.xlsx")){
  batch.adds.input <- read_xlsx(path = "batch_addresses_in.xlsx")
  batch.adds.output <- cxy_geocode(batch.adds.input, 
                                   street = 'street_address', 
                                   city = 'city', 
                                   state = 'state', 
                                   zip = 'zipcode',
                                   return = 'locations', # 'locations' or 'geographies'
                                   class = 'dataframe',  # 'dataframe' or 'sf' 
                                   output = 'full')      # 'simple' or 'full' 
  
  readr::write_csv(x = batch.adds.output, file = "batch_addresses_out.csv")
  print("geocoding process complete")
  print(paste("see file 'batch_addresses_out.csv' in", getwd()))
}else{
  print(paste("Skipping Batch Geocoding Process: No file named 'batch_addresses_in.xlsx' in ", getwd()))
}
