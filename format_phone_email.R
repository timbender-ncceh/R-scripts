library(dplyr)
#rm(list=ls());cat('\f')

# import areacodes----
areacodes <- read_csv("https://raw.githubusercontent.com/ravisorg/Area-Code-Geolocation-Database/master/us-area-code-cities.csv",
                      col_names = F)
areacodes <- unique(areacodes$X1)

format_pn <- function(txt, pre_process = T){
  # preprocess logic (optional): before splitting strings at "space" character,
  # looks for patterns of 10 number digits in a row (optionally broken by "-" or
  # "." as you would commonly write a phone number 303-555-1234), and if there is
  # a space anywhere in that string of 10 digits, removes that space.  in
  # testing, caused an error 7 times in 17,146 tries on real data.)
  
  # skip this logic by using the argument 'pre_process = FALSE'
  if(pre_process){
    txt <- gsub(pattern = "(?<=\\d{3,3})\\W{0,1}\\D{0,1} {0,1}\\W{0,1}(?=\\d{3,4})",
                replacement = "-",
                txt,
                perl = T) 
  }
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
format_pn("303-555- 1234", pre_process = TRUE) # [1] "3035551234"
format_pn("303-555- 1234", pre_process = FALSE) # [1] NA
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
