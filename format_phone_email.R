library(dplyr)
#rm(list=ls());cat('\f')

# import areacodes----
areacodes <- read_csv("https://raw.githubusercontent.com/ravisorg/Area-Code-Geolocation-Database/master/us-area-code-cities.csv",
                      col_names = F)
areacodes <- unique(areacodes$X1)

# funs----
# a simple formula for generating fake 10-digit phone numbers for testing purposes
gen_pn <- function(fivefivefive = T, sep1 = "-"){
  require(glue)
  if(fivefivefive){
    out <- glue("{sample(areacodes, size = 1)}{sep1}555{sep1}{paste(sample(0:9,4,replace=T), sep = \"\", collapse = \"\")}")
  }else{
    out <- glue("{sample(areacodes, size = 1)}{sep1}{paste(sample(1:9,1,replace=T), sep = \"\", collapse = \"\")}{paste(sample(0:9,2,replace=T), sep = \"\", collapse = \"\")}{sep1}{paste(sample(0:9,4,replace=T), sep = \"\", collapse = \"\")}")
  }
  return(out)
  }

set.seed(1)
gen_pn() # [1] 646-555-0161

format_pn <- function(txt){
  # basic find-replace for non-word characters (i.e. '\\W') OR non-numeral characters ('\\D')
  temp <- trimws(gsub("\\W|\\D", "", unlist(strsplit(x = txt, split = " ")))) %>%
    grep(pattern = paste("^", areacodes, sep = "", collapse = "|"), x = ., 
         value = T)
  
  # check that remaining phone number is 10 digits
  temp <- temp[nchar(temp) == 10]
  
  # if input text (txt) fails all logic and var "temp" is now empty, assign NA to "temp"  
  if(length(temp) == 0){
    temp <- NA
  }
  return(temp)
}

# Examples:
format_pn("555-1234") # [1] NA
format_pn("303-555-1234") # [1] "3035551234"
format_pn("1+303-555-1234")# [1] NA
format_pn("303-555-1234 (step sons cell phone)")# [1] "3035551234

# email----

format_em <- function(txt){
  out <- unlist(strsplit(x = txt, split = " ")) 
  # split apart the string where words are separated by spaces
  out <- out[grepl("@", x = out)] 
  # identify and keep every word that has an "@" in it (because that's an email)
  
  out <- gsub("\\W$", "", out)   
  # cleanup: if the input string had commas or other proper punctuation separating words, remove those
  out <- unique(out) 
  # remove duplicate emails
  
  if(length(unique(out)) > 1){ 
    # evaluate if there is just 1 email provided
    out <- NA  
    # if there are 2 or more provided, return NA (can be changed in the future depending on how you want to handle)
  }
  if(length(unique(out)) < 1){
    out <- NA 
    # if there are 0 provided, return NA (can be changed depending on how you want to handle it)
  }
  return(out)
  # return whatever is left 
}

# Examples:
format_em("someonesname@someemail.com (son's email)") #[1] "someonesname@someemail.com"
format_em("someonesname@someemail.com") #[1] "someonesname@someemail.com"
format_em("someonesname@someemail.com, another@email.com") #[1] NA
