# AUTHOR: JMZ
# Modified: 12/21/18
# Script code to create the kernel entries for the isotropic, geometric and ross kernels to form the matrix K, for each site.  Allows us to access the data later

# Reads in the data provided MODIS Appears

library(tidyverse)
library(devtools)

#source("kernelFunctions.R")  # Not needed to source this because it is in the R file



inData_MOD <- read_csv('data-raw/fluxnet-dbf-mod-v2/Fluxnet-DBF-MOD-V2-MOD09GA-006-results.csv')
inData_MYD <- read_csv('data-raw/fluxnet-combined-myd/Fluxnet-Combined-MYD09GA-006-results.csv')



### This is very hacky, but we are going to just change the names of MYD so they are consistent and we can bind them together
names(inData_MYD) <- names(inData_MOD)

inData <- rbind(inData_MOD,inData_MYD)



bands <- data.frame(
  band1 = inData$MOD09GA_006_sur_refl_b01_1,
  band2 = inData$MOD09GA_006_sur_refl_b02_1,
  band3 = inData$MOD09GA_006_sur_refl_b03_1,
  band4 = inData$MOD09GA_006_sur_refl_b04_1,
  band5 = inData$MOD09GA_006_sur_refl_b05_1,
  band6 = inData$MOD09GA_006_sur_refl_b06_1,
  band7 = inData$MOD09GA_006_sur_refl_b07_1)

bandsFlag <- bands

# Determine the state of the measurement
stateFlagData <- data.frame(
  cloud_state = inData$MOD09GA_006_state_1km_1_cloud_state, #0b00
  cloud_shadow = inData$MOD09GA_006_state_1km_1_cloud_shadow,#0b0
  #  land_water=inData$`MOD09GA_006_state_1km_1_land/water_flag`,#0b001 (always because on land?)
  aerosol=inData$MOD09GA_006_state_1km_1_aerosol_quantity, #0b00
  cirrus=inData$MOD09GA_006_state_1km_1_cirrus_detected, #0b00
  internal_cloud=inData$MOD09GA_006_state_1km_1_internal_cloud_algorithm_flag, #0b0
  internal_fire=inData$MOD09GA_006_state_1km_1_internal_fire_algorithm_flag,#0b0
  snow_ice=inData$`MOD09GA_006_state_1km_1_MOD35_snow/ice_flag`,#0b0
  next_to_clous=inData$MOD09GA_006_state_1km_1_Pixel_is_adjacent_to_cloud, #0b0
  Salt_pan=inData$MOD09GA_006_state_1km_1_Salt_pan,#0b0
  internal_snow=inData$MOD09GA_006_state_1km_1_internal_snow_mask) #0b0


state_flag_matrix <- stateFlagData

# Determine the QA Band
bandsFlagData <- data.frame(
  flag_band_1 = inData$MOD09GA_006_QC_500m_1_band_1_data_quality_four_bit_range,
  flag_band_2 = inData$MOD09GA_006_QC_500m_1_band_2_data_quality_four_bit_range,
  flag_band_3 = inData$MOD09GA_006_QC_500m_1_band_3_data_quality_four_bit_range,
  flag_band_4 = inData$MOD09GA_006_QC_500m_1_band_4_data_quality_four_bit_range,
  flag_band_5 = inData$MOD09GA_006_QC_500m_1_band_5_data_quality_four_bit_range,
  flag_band_6 = inData$MOD09GA_006_QC_500m_1_band_6_data_quality_four_bit_range,
  flag_band_7 = inData$MOD09GA_006_QC_500m_1_band_7_data_quality_four_bit_range)

bands_flag_matrix <- bandsFlagData

for (i in 1:dim(bandsFlagData)[2]) {
  bands_flag_matrix[,i] <- bandsFlagData[,i] %>% str_detect("0b0000")
  bandsFlag[,i] <- bands[,i]!=-28672
}

for (i in 1:dim(stateFlagData)[2]) {

  state_flag_matrix[,i] <- stateFlagData[,i] %>% str_detect("0b0|0b00")

}


# Compute the solar and viewing angles (convert to radians)
sza <- inData$MOD09GA_006_SolarZenith_1*pi/180
vza <- inData$MOD09GA_006_SensorZenith_1*pi/180
#
saa <- inData$MOD09GA_006_SolarAzimuth_1*pi/180
vaa <- inData$MOD09GA_006_SensorAzimuth_1*pi/180



h_b = 2 ;
b_r = 1 ;

#yee <- correct_angles(sza,vza,saa,vaa)

K_RossThick <- array(0,dim=dim(inData)[1])
K_LiSparse <- array(0,dim=dim(inData)[1])
for(i in seq_along(K_RossThick)) {

  new_angles <- correct_angles(sza[i],vza[i],saa[i]-vaa[i])


  K_RossThick[i] <- ross_thick_k(new_angles$.sza,new_angles$.vza,new_angles$.raa)
  K_LiSparse[i] <- li_sparse_k(new_angles$.sza,new_angles$.vza,new_angles$.raa,h_b,b_r)
}

fluxnet <- inData %>%
  select(ID,Date) %>%
  rename(site=ID,time=Date) %>%
  mutate(time=yday(time),K_Iso=1,K_RossThick,K_LiSparse,bands_flags=rowSums(bands_flag_matrix),states_flag=rowSums(state_flag_matrix)) %>%
  bind_cols(bands) %>%
  filter(bands_flags ==7 & states_flag == 10) %>%
  select(-bands_flags,-states_flag) %>%
  arrange(site,time)


### Yay!  We just need to solve this out and form the K matrix ....

use_data(fluxnet,overwrite = TRUE)
