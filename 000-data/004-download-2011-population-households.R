# This script downloads 
# the Population and Households data from the Census 2011
# from Nomis Web through nomisr
#
# under the Open Government Licence v3.0 
# https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/
#
# and including previously downloaded data
#
# Result contains both Ordnance Survey and ONS Intellectual Property Rights.
# 
# Author: Stefano De Sabbata
# Date: 09 November 2022

library(tidyverse)
library(magrittr)
library(nomisr)
library(sf)


oa_2011_geo <-
  st_read("storage/Leicester_2011_OAs.geojson")

population_2011 <- 
  nomis_get_data(
    id = "NM_144_1",       # Usual resident population (KS101EW)
    geography = 
      oa_2011_geo %>% 
      st_drop_geometry() %>% 
      pull(OA11CD),
    tidy = TRUE
  ) %>% 
  filter(
    cell_code %in% c("KS101EW0001") & 
      rural_urban == 0 &
      measures_name == "Value"
  ) %>% 
  select(geography_code, cell_code, obs_value) %>% 
  pivot_wider(
    id_cols = geography_code,
    names_from = cell_code,
    values_from = obs_value
  ) %>% 
  rename(
    OA11CD = geography_code,
    all_persons_2011 = KS101EW0001
  )

households_2011 <- 
  nomis_get_data(
    id = "NM_605_1",       # Household composition (KS105EW)
    geography = 
      oa_2011_geo %>% 
      st_drop_geometry() %>% 
      pull(OA11CD),
    tidy = TRUE
  ) %>% 
  filter(
    cell_code %in% c("KS105EW0001") & 
      rural_urban == 0 &
      measures_name == "Value"
  ) %>% 
  select(geography_code, cell_code, obs_value) %>% 
  pivot_wider(
    id_cols = geography_code,
    names_from = cell_code,
    values_from = obs_value
  ) %>% 
  rename(
    OA11CD = geography_code,
    households_2011 = KS105EW0001
  )

oa_2011_geo %>% 
  left_join(population_2011) %>% 
  left_join(households_2011) %>% 
  st_write("storage/Leicester_2011_OAs_population_households.geojson")