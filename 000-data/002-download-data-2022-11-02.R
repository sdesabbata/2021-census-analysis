# This script downloads 
# the Demography and migration data, England and Wales: Census 2021
# https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/articles/demographyandmigrationdatacontent/2022-11-02#demography-unrounded-population-estimates
#
# Released on 2 November 2022
# under the Open Government Licence v3.0 
# https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/
# 
# Author: Stefano De Sabbata
# Date: 04 November 2022


# Libraries ---------------------------------------------------------------

library(tidyverse)
library(readxl)



# Data download -----------------------------------------------------------

cat("Retrieving data\n")


urls <- c(
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS041_households/atc-ts-demmig-hh-ct-oa-oa.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS006_population_density/atc-ts-demmig-ur-pd-oa-oa.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS008_sex/UR-oa%2Bsex.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS003_hh_family_composition_15a/HH-oa%2Bhh_family_composition_15a_east_midlands.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS017_hh_size_9a/HH-oa%2Bhh_size_9a_east_midlands.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS011_hh_deprivation/HH-oa%2Bhh_deprivation_east_midlands.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS002_legal_partnership_status/UR-oa%2Blegal_partnership_status_east_midlands.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS001_residence_type/atc-ts-demmig-ur-ct-oa-oa%2Bresidence_type.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS018_age_arrival_uk_18a/atc-ts-demmig-ur-ct-oa-oa%2Bage_arrival_uk_18a_east_midlands.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS004_country_of_birth_12a/atc-ts-demmig-ur-ct-oa-oa%2Bcountry_of_birth_12a_east_midlands.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS016_residence_length_6b/UR-oa%2Bresidence_length_6b_east_midlands.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS019_migrant_ind/UR-oa%2Bmigrant_ind.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS020_sex/atc-ts-demmig-str-ct-oa-oa%2Bsex.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS005_passports_all_27a/UR-oa%2Bpassports_all_27a_east_midlands.xlsx",
  "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS015_year_arrival_uk/UR-oa%2Byear_arrival_uk_east_midlands.xlsx"
)

for (this_url in urls) {
  
  census_file <-
    this_url %>% 
    str_split("/") %>% 
    flatten() %>% 
    as_vector() %>% 
    last() %>% 
    str_replace_all("%2B", "\\+") %>% 
    paste0("storage/", .)
  
  if (!file.exists(file.path(census_file))) {
    
    cat(census_file)
    cat("\n")
    
    # Download file
    download.file(
      url = this_url,
      destfile = census_file
    )
    
  }
  
  census_file_csv <-
    census_file %>% 
    str_replace(".xlsx", ".csv")
  
  if (!file.exists(file.path(census_file_csv))) {
    
    cat(census_file_csv)
    cat("\n")
    
    # Extract table to csv
    read_excel(
        census_file,
        sheet = "Table"
      ) %>% 
      write_csv(census_file_csv)
    
  }
}