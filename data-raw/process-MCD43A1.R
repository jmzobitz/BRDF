
# AUTHOR: JMZ
# Modified: 12/24/18
# Script code to process kernel weights

# Read in APPEARS albedo data for comparison


library(tidyverse)
library(lubridate)
library(devtools)

modisBRDF_data <- read_csv('data-raw/fluxnet2015-brdf/Fluxnet2015-BRDF-MCD43A1-006-results.csv') %>%
  select(ID,Date,
         matches("_Albedo_Parameters_Band")) %>%
  rename(time=Date,site=ID) %>%
  mutate(time = yday(time)) %>%
  gather(key=band_str,value=value,-time,-site) %>%
  mutate(kernel=str_extract(band_str,".$"),band=str_extract(band_str, "Band.")) %>%
  mutate(band=str_to_lower(band)) %>%
  select(-band_str) %>%
  arrange(site,time,kernel)

# Pull out the flags
modisBRDF_flags <- read_csv('data-raw/fluxnet2015-brdf/Fluxnet2015-BRDF-MCD43A1-006-results.csv') %>%
  select(ID,Date,
         matches("Mandatory_Quality_Band")) %>%
  select(-matches("bitmask|MODLAND|Fill")) %>%   # We need to remove some that aren't pertinent
  rename(time=Date,site=ID) %>%
  mutate(time = yday(time)) %>%
  gather(key=band_str,value=flag,-time,-site) %>%
  mutate(band=str_extract(band_str, "Band.$")) %>%  # Search for the end of string
  mutate(band=str_to_lower(band)) %>%
  select(-band_str)

# Now join the two datasets together, filter out good flags
modisBRDF <- modisBRDF_data %>%
  left_join(modisBRDF_flags,by=c("site","time","band")) %>%
  filter(flag==0) %>%
  select(-flag)

# From https://lpdaac.usgs.gov/dataset_discovery/modis/modis_products_table/mcd43a1_v006
#*Mandatory QA bit index:
#  0 = processed, good quality (full BRDF inversions)
#1 = processed, see other QA (magnitude BRDF inversions)
#255 = Fill Value



use_data(modisBRDF,overwrite = TRUE)

