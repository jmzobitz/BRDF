### Code that creates the uncertainty on each reflectance band
### Uncertainties provided by Tristan
library(devtools)
band = c("band1","band2","band3","band4","band5","band6","band7")
sigma = c( 0.005,0.014,0.008,0.005,0.012,0.006,0.003)

band_uncertainty<-data.frame(band,sigma)
use_data(band_uncertainty,overwrite = TRUE)
