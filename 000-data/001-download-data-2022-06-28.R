# This script downloads 
# the Population and household estimates, England and Wales: Census 2021
# https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationandhouseholdestimatesenglandandwalescensus2021
#
# Released on 28 June 2022
# under the Open Government Licence v3.0 
# https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/
# 
# Author: Stefano De Sabbata
# Date: 28 June 2022


# Libraries ---------------------------------------------------------------

library(tidyverse)



# Data download -----------------------------------------------------------

cat("Retrieving data\n")

census_file <- "census2021firstresultsenglandwales1.xlsx"

if (!file.exists(file.path(paste0("storage/", census_file)))) {
  
  # Download file
  download.file(
    url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationandhouseholdestimatesenglandandwalescensus2021/census2021/census2021firstresultsenglandwales1.xlsx",
    destfile = paste0(
      "storage/",
      census_file
    )
  )
  
}