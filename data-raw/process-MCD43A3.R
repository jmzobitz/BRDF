# AUTHOR: JMZ
# Modified: 12/21/18
# Script code to create albedo data (white sky albedo) for each site.  Allows us to access the data later

# Read in APPEARS albedo data for comparison


library(tidyverse)
library(lubridate)
library(devtools)

modisAlbedoData_BSA <- read_csv('data-raw/fluxnet-combined-albedo-black-sky/Fluxnet-Combined-Albedo-Black-Sky-MCD43A3-006-results.csv') %>%
  select(ID,Date,
         MCD43A3_006_Albedo_BSA_Band1,
         MCD43A3_006_Albedo_BSA_Band2,
         MCD43A3_006_Albedo_BSA_Band3,
         MCD43A3_006_Albedo_BSA_Band4,
         MCD43A3_006_Albedo_BSA_Band5,
         MCD43A3_006_Albedo_BSA_Band6,
         MCD43A3_006_Albedo_BSA_Band7,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band1,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band2,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band3,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band4,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band5,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band6,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band7)



# here if QA = 0, we have good quality.
# only take if we have QA = 0 across all bands

flagValues = modisAlbedoData_BSA %>% select(10,16) %>% rowSums()

mcd43A3_BlackSkyAlbedo <- modisAlbedoData_BSA %>% mutate(flagValues) %>%
  filter(flagValues==0) %>%
  select(1:9) %>%
  rename("1"=MCD43A3_006_Albedo_BSA_Band1,
         "2"=MCD43A3_006_Albedo_BSA_Band2,
         "3"=MCD43A3_006_Albedo_BSA_Band3,
         "4"=MCD43A3_006_Albedo_BSA_Band4,
         "5"=MCD43A3_006_Albedo_BSA_Band5,
         "6"=MCD43A3_006_Albedo_BSA_Band6,
         "7"=MCD43A3_006_Albedo_BSA_Band7,
         site=ID) %>%
  mutate(time=yday(Date),method="mcd43A3",type="black-sky") %>%
  select(-Date) %>%
  gather(key=band,value=bs,"1","2","3","4","5","6","7")


### Now do white sky albedo
# Read in APPEARS albedo data for comparison


modisAlbedoData_WSA <- read_csv('data-raw/fluxnet-combined-albedo-black-sky/Fluxnet-Combined-Albedo-Black-Sky-MCD43A3-006-results.csv') %>%
  select(ID,Date,
         MCD43A3_006_Albedo_WSA_Band1,
         MCD43A3_006_Albedo_WSA_Band2,
         MCD43A3_006_Albedo_WSA_Band3,
         MCD43A3_006_Albedo_WSA_Band4,
         MCD43A3_006_Albedo_WSA_Band5,
         MCD43A3_006_Albedo_WSA_Band6,
         MCD43A3_006_Albedo_WSA_Band7,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band1,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band2,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band3,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band4,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band5,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band6,
         MCD43A3_006_BRDF_Albedo_Band_Mandatory_Quality_Band7)



# here if QA = 0, we have good quality.
# only take if we have QA = 0 across all bands

flagValues = modisAlbedoData_WSA %>% select(10,16) %>% rowSums()

mcd43A3_WhiteSkyAlbedo <- modisAlbedoData_WSA %>% mutate(flagValues) %>%
  filter(flagValues==0) %>%
  select(1:9) %>%
  rename("1"=MCD43A3_006_Albedo_WSA_Band1,
         "2"=MCD43A3_006_Albedo_WSA_Band2,
         "3"=MCD43A3_006_Albedo_WSA_Band3,
         "4"=MCD43A3_006_Albedo_WSA_Band4,
         "5"=MCD43A3_006_Albedo_WSA_Band5,
         "6"=MCD43A3_006_Albedo_WSA_Band6,
         "7"=MCD43A3_006_Albedo_WSA_Band7,
         site=ID) %>%
  mutate(time=yday(Date),method="mcd43A3",type="white-sky") %>%
  select(-Date) %>%
  gather(key=band,value=bs,"1","2","3","4","5","6","7")

mcd43A3 <- rbind(mcd43A3_BlackSkyAlbedo,mcd43A3_WhiteSkyAlbedo)

use_data(mcd43A3,overwrite = TRUE)

