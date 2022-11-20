library(dplyr)
rm(list=ls());cat('\f')

# funs----
format_pn <- function(txt, sep = "-", ndig = 10){
  txt <- as.character(txt)
  # remove non-numeric chars
  out <- gsub("\\W|\\D", "", txt) 
  # check number of digits
  if(nchar(out) != ndig){
    if(first(unlist(strsplit(out, "")))!= "1"){
      out <- NA
      #stop("check input; input doesn't match desired number of digits")
    }else{
      out <- unlist(strsplit(out, ""))
      out <- out[2:length(out)]
      out <- paste(out, sep = "", collapse = "")
    }
  }
  # format 
  if(!is.na(out)){
    out.a <- substr(out, 1, 3)
    out.b <- substr(out, 4, 6)
    out.c <- substr(out, 7,10)
    out <- paste(out.a, out.b, out.c, sep = sep, collapse = sep)
  }
  # return
  return(out)
}

# Examples:
format_pn("555-5555") # [1] NA
format_pn("555-555-1234") # [1] "555-555-1234
format_pn("1+555-555-1234")# [1] "555-555-1234
format_pn("555-555-1234 (step sons cell phone)")# [1] "555-555-1234

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
