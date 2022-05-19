####################################
#####.........README...........#####
####################################
#---- Purpose of this Script
#       * Simple, rapid, no-cost geocoding of mailing addresses stored in a 
#         spreadsheet

#---- Installing R (https://cran.r-project.org/)
#       * This tool runs in the R environment
#       * https://cran.r-project.org/

#---- To Use the tool
#       1) create a new folder, preferably on your C:/ drive 
#         i.e. 'C:\Users\<YourName>\Documents\geocode_folder\'
#       2) open script in web browser: 
#         https://raw.githubusercontent.com/timbender-ncceh/R-scripts/main/batch_geocode.R
#       3) <right-click> and save-as "batch_geocode.R" in the new folder 
#       4) place a copy of the spreadsheet "batch_addresses_in.xlsx" in the new folder
#           - This spreadsheet can only have 1 sheet of data (i.e. "Sheet1")
#           - This spreadsheet must have 4 columns labeled exactly as follows: 
#               1. street_address (data required always)
#               2. city           (1 of 3 can be missing data)
#               3. state          (1 of 3 can be missing data)
#               4. zipcode        (1 of 3 can be missing data)
#       5) double-click "batch_geocode.R" file to run tool
#       6) script will generate a .csv file named "batched_addressed_out.csv" with results


#---- Support
#       If you have followed these directions but the tool does not function as 
#       you believe it should , please contact Tim Bender at tim.bender@ncceh.org.
#       Include a description of the problem and a copy of your .xlsx file in 
#       the email and I'll try to help.  
####################################
#####......../README...........#####
####################################
