# Geocode Tool
# https://cran.r-project.org/web/packages/censusxy/vignettes/censusxy.html

# Load Necessary Libraries only----
library(censusxy)
library(tidycensus)
library(tigris)

#Sys.getenv("CENSUS_API_KEY") # check census api key
options(tigris_use_cache = F)

rm(list=ls());cat('\f')

# functions----
geoid_tract <- function(gt){
  if(nchar(gt)!=11){
    stop("geoid must be 11 chars long")
  }
  return(c(state = substr(gt,1,2), county = substr(gt,3,5), tract = substr(gt,6,11)))
}

# batch geocode from neat spreadsheet----
x <- stl_homicides[1:10,]
x

cxy_geocode(x, 
            street = 'street_address', 
            city = 'city', 
            state = 'state', 
            zip = 'postal_code',
            return = 'locations', # 'locations' or 'geographies'
            class = 'dataframe',  # 'dataframe' or 'sf' 
            output = 'full')   # 'simple' or 'full' 

# geocode an un-processed address----
an.add <- "1060 W Addison St, Chicago, IL 60613"

add1 <- as_tibble(cxy_oneline(address = an.add)) 
add1

# get geoid for tract----
geoid.add1 <- tigris::append_geoid(address = data.frame(lat = add1$coordinates.y, 
                                                        lon = add1$coordinates.x), 
                                   geoid_type = "tract")$geoid

# get state, county, tract breakout from geoid----
geoid.tract1 <- geoid_tract(gt = geoid.add1)

# find median hh income for that tract----
vars.2020_acs5 <- load_variables(2020,"acs5") # prints all the names of the vars for the 5-year american community survey for 2020
mhh.inc.var <- vars.2020_acs5[vars.2020_acs5$concept == "MEDIAN HOUSEHOLD INCOME IN THE PAST 12 MONTHS (IN 2020 INFLATION-ADJUSTED DOLLARS)",]$name

acs.data <- get_acs(geography = "tract", variables = mhh.inc.var,
                state = geoid_tract(geoid.add1)["state"], 
                county = geoid_tract(geoid.add1)["county"], 
                geometry = F, year = 2020) %>% .[.$GEOID == geoid.add1,]

print(acs.data)
