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
