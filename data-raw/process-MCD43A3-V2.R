# AUTHOR: JMZ
# Modified: 12/21/18
# Script code to create albedo data (white sky albedo) for each site.  Allows us to access the data later

# Read in APPEARS albedo data for comparison


library(tidyverse)
library(lubridate)
library(devtools)


# Pull in the black sky albedo and filter
modisAlbedoData_BSA <- read_csv('data-raw/fluxnet-combined-albedo-black-sky/Fluxnet-Combined-Albedo-Black-Sky-MCD43A3-006-results.csv') %>%
  select(ID,Date,
         matches("_Albedo_BSA_Band")) %>%
  rename(time=Date,site=ID) %>%   # Rename the columns
  mutate(time = yday(time)) %>%
  gather(key=band_str,value=value,-time,-site) %>%  # Gather by site and time
  mutate(kernel=str_extract(band_str,".$"),band=str_extract(band_str, "Band.")) %>% # Add columns for the kernel and reflectance band
  mutate(band=str_to_lower(band)) %>%  # Convert to lower case
  select(-band_str) %>%
  arrange(site,time,kernel)

# Pull in the white sky albedo and filter
modisAlbedoData_WSA <- read_csv('data-raw/fluxnet-combined-albedo-black-sky/Fluxnet-Combined-Albedo-Black-Sky-MCD43A3-006-results.csv') %>%
  select(ID,Date,
         matches("_Albedo_WSA_Band")) %>%
  rename(time=Date,site=ID) %>%   # Rename the columns
  mutate(time = yday(time)) %>%
  gather(key=band_str,value=value,-time,-site) %>%  # Gather by site and time
  mutate(kernel=str_extract(band_str,".$"),band=str_extract(band_str, "Band.")) %>% # Add columns for the kernel and reflectance band
  mutate(band=str_to_lower(band)) %>%  # Convert to lower case
  select(-band_str) %>%
  arrange(site,time,kernel)


modisAlbedo_flag <- read_csv('data-raw/fluxnet-combined-albedo-black-sky/Fluxnet-Combined-Albedo-Black-Sky-MCD43A3-006-results.csv') %>%
    select(ID,Date,
           matches("_Mandatory_Quality_Band")) %>%
    select(-matches("bitmask|MODLAND|Fill")) %>% # Remove the extra pieces
    rename(time=Date,site=ID) %>%   # Rename the columns
    mutate(time = yday(time)) %>%
  gather(key=band_str,value=flag,-time,-site) %>%
  mutate(band=str_extract(band_str, "Band.$")) %>%  # Search for the end of string
  mutate(band=str_to_lower(band)) %>%
  select(-band_str)


# From the APPEARS webpage:
# *Mandatory QA bit index:
#   0 = processed, good quality (full BRDF inversions)
# 1 = processed, see other QA (magnitude BRDF inversions)
# 255 = Fill Value


# here if QA = 0, we have good quality.
# only take if we have QA = 0 across all bands

# Now join the two datasets together, filter out good flags
BSA_filtered <- modisAlbedoData_BSA %>%
  left_join(modisAlbedo_flag,by=c("site","time","band")) %>%
  filter(flag==0) %>%
  select(-flag) %>%
  mutate(type='black-sky')

# Now join the two datasets together, filter out good flags
WSA_filtered <- modisAlbedoData_WSA %>%
  left_join(modisAlbedo_flag,by=c("site","time","band")) %>%
  filter(flag==0) %>%
  select(-flag) %>%
  mutate(type='white-sky')


### Now do white sky albedo
# Read in APPEARS albedo data for comparison



mcd43A3 <- rbind(BSA_filtered,WSA_filtered)

use_data(mcd43A3,overwrite = TRUE)

