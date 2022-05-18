# Batch Geocode Tool
# https://cran.r-project.org/web/packages/censusxy/vignettes/censusxy.html

library(ggplot2)
library(dplyr)
library(data.table)
library(lubridate)
library(readr)
library(ggmap)
# for geocoding and census data
library(censusxy)
library(tidycensus)

rm(list=ls());cat('\f')

# Vars----
wd <- "C:/Users/TimBender/Documents/R"
setwd(wd)

# example----
stl_homicides
args(cxy_geocode)
homicide_sf <- cxy_geocode(stl_homicides[1:10,], 
                           street = "street_address", 
                           city = "city", 
                           state = "state", 
                           zip = "postal_code", class = "sf")


ggplot() + 
  geom_sf(data = homicide_sf)
