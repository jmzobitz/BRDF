TABLE OF CONTENTS
-----------------
                                               Section
Request Parameters ................................. 1
Request File Listing ............................... 2
Point Sample Extraction Process .................... 3
Data Quality ....................................... 4
  Moderate Resolution Imaging
    Spectroradiometer (MODIS) .................... 4.1
  NASA MEaSUREs Web Enabled
    Landsat Data (WELD) .......................... 4.2
  NASA MEaSUREs Shuttle Radar Topography
    Mission (SRTM) Version 3 (v3) ................ 4.3
  Gridded Population of the World (GPW)
    Version 4 (v4) ............................... 4.4
  Suomi National Polar-orbiting Partnership (S-NPP)
	NASA Visible Infrared Imaging Radiometer Suite
	(VIIRS)....................................... 4.5
  Soil Moisture Active Passive (SMAP)............. 4.6
Documentation ...................................... 5
Sample Request Retention ........................... 6
Data Product Citations ............................. 7
Feedback ........................................... 8



1. Request Parameters
   ------------------
Name: Fluxnet Combined Albedo Black Sky
Date Completed: 2018-09-19T06:03:42.144000
Id: fcdaceb7-d6ed-4b2d-825e-14b6045d8e38
Details:
  Start Date: 01-01-2017
  End Date: 12-31-2017
  Layers:
      Albedo_BSA_Band1 (MCD43A3.006)
      Albedo_BSA_Band2 (MCD43A3.006)
      Albedo_BSA_Band3 (MCD43A3.006)
      Albedo_BSA_Band4 (MCD43A3.006)
      Albedo_BSA_Band5 (MCD43A3.006)
      Albedo_BSA_Band6 (MCD43A3.006)
      Albedo_BSA_Band7 (MCD43A3.006)
      Albedo_BSA_nir (MCD43A3.006)
      Albedo_BSA_shortwave (MCD43A3.006)
      Albedo_BSA_vis (MCD43A3.006)
      Albedo_WSA_Band1 (MCD43A3.006)
      Albedo_WSA_Band2 (MCD43A3.006)
      Albedo_WSA_Band3 (MCD43A3.006)
      Albedo_WSA_Band4 (MCD43A3.006)
      Albedo_WSA_Band5 (MCD43A3.006)
      Albedo_WSA_Band6 (MCD43A3.006)
      Albedo_WSA_Band7 (MCD43A3.006)
      Albedo_WSA_nir (MCD43A3.006)
      Albedo_WSA_shortwave (MCD43A3.006)
      Albedo_WSA_vis (MCD43A3.006)
      BRDF_Albedo_Band_Mandatory_Quality_Band1 (MCD43A3.006)
      BRDF_Albedo_Band_Mandatory_Quality_Band2 (MCD43A3.006)
      BRDF_Albedo_Band_Mandatory_Quality_Band3 (MCD43A3.006)
      BRDF_Albedo_Band_Mandatory_Quality_Band4 (MCD43A3.006)
      BRDF_Albedo_Band_Mandatory_Quality_Band5 (MCD43A3.006)
      BRDF_Albedo_Band_Mandatory_Quality_Band6 (MCD43A3.006)
      BRDF_Albedo_Band_Mandatory_Quality_Band7 (MCD43A3.006)
      BRDF_Albedo_Band_Mandatory_Quality_nir (MCD43A3.006)
      BRDF_Albedo_Band_Mandatory_Quality_shortwave (MCD43A3.006)
      BRDF_Albedo_Band_Mandatory_Quality_vis (MCD43A3.006)
  Coordinates:
      AU-Lox, DBF, -34.4704, 140.6551
      CA-Oas, DBF, 53.6289, -106.1978
      CA-TPD, DBF, 42.6353, -80.5577
      DE-Hai, DBF, 51.0792, 10.453
      DE-Lnf, DBF, 51.3282, 10.3678
      DK-Sor, DBF, 55.4859, 11.6446
      FR-Fon, DBF, 48.4764, 2.7801
      IT-CA1, DBF, 42.3804, 12.0266
      IT-CA3, DBF, 42.38, 12.0222
      IT-Col, DBF, 41.8494, 13.5881
      IT-Isp, DBF, 45.8126, 8.6336
      IT-PT1, DBF, 45.2009, 9.061
      IT-Ro1, DBF, 42.4081, 11.93
      IT-Ro2, DBF, 42.3903, 11.9209
      JP-MBF, DBF, 44.3869, 142.3186
      PA-SPn, DBF, 9.3181, -79.6346
      US-Ha1, DBF, 42.5378, -72.1715
      US-MMS, DBF, 39.3232, -86.4131
      US-Oho, DBF, 41.5545, -83.8438
      US-UMB, DBF, 45.5598, -84.7138
      US-UMd, DBF, 45.5625, -84.6975
      US-WCr, DBF, 45.8059, -90.0799
      US-Wi1, DBF, 46.7305, -91.2329
      US-Wi3, DBF, 46.6347, -91.0987
      US-Wi8, DBF, 46.7223, -91.2524
      ZM-Mon, DBF, -15.4378, 23.2528

Version:
    This request was processed by AppEEARS version 2.10


2. Request File Listing
   --------------------

Fluxnet-Combined-Albedo-Black-Sky-MCD43A3-006-results.csv
  Comma-separated values file with data extracted for a specific product

Fluxnet-Combined-Albedo-Black-Sky-granule-list.txt
  Text file with data pool URLs for all source granules used in the extraction

Fluxnet-Combined-Albedo-Black-Sky-request.json
  JSON request file which can be used in AppEEARS to create a new request

Fluxnet-Combined-Albedo-Black-Sky-MCD43A3-006-metadata.xml
  xml file



3. Point Sample Extraction Process
   -------------------------------
Datasets available in AppEEARS are served via OPeNDAP (Open-source Project for
a Network Data Access Protocol) services. OPeNDAP services allow users to
concisely pull pixel values from datasets via HTTP requests. A middleware layer
has been developed to interact with the OPeNDAP services. The middleware make
it possible to extract scaled data values, with associated information, for
pixels corresponding to a given coordinate and date range.

NOTE:
  - Requested date ranges may not match the reference date for multi-day
  products. AppEEARS takes an inclusive approach when extracting data for
  sample requests, often returning data that extends beyond the requested
  date range. This approach ensures that the returned data includes records for
  the entire requested date range.
  - For multi-day (8-day, 16-day, Monthly, Yearly) MODIS and S-NPP NASA VIIRS
  datasets, the date field in the data tables reflects the first day of the
  composite period.
  - For WELD products (Weekly, Monthly, Seasonal, Yearly), the date field
  in the data tables reflects the first day of the composite period.
  - If selected, the SRTM v3 product will be extracted regardless of the time
  period specified in AppEEARS because it is a static dataset. The date field
  in the data tables reflects the nominal SRTM date of February 11, 2000.
  - If the visualizations indicate that there are no data to display, proceed
  to downloading the .csv output file. Data products that have both categorical
  and continuous data values (e.g. MOD15A2H) are not able to be displayed within
  the visualizations within AppEEARS.


4. Data Quality
   ------------
When available, AppEEARS extracts and returns quality assurance (QA) data for
each data file returned regardless of whether the user requests it. This is
done to ensure that the user possesses the information needed to determine the
usability and usefulness of the data they get from AppEEARS. Most data products
available through AppEEARS have an associated QA data layer. Some products have
more than one QA data layer to consult. See below for more information
regarding data collections/products and their associated QA data layers.

 4.1 MODIS (Terra, Aqua, & Combined)
     -------------------------------
  All MODIS land products, as well as the MODIS Snow Cover Daily product,
  include quality assurance (QA) information designed to help users understand
  and make best use of the data that comprise each product. Results downloaded
  from AppEEARS and/or data directly requested via middleware services contain
  not only the requested pixel/data values but also the decoded QA information
  associated with each pixel/data value extracted.
  - See the MODIS Land Products QA Tutorials
  (https://lpdaac.usgs.gov/user_resources/e_learning) for more QA information
  regarding each MODIS land product suite.
 - See the MODIS Snow Cover Daily product user guide for information
  regarding QA utilization and interpretation.

 4.2 NASA MEaSUREs WELD (CONUS & Alaska)
     -----------------------------------
  Each WELD product contains a pixel saturation band and two cloud detection
  bands generated using the Landsat automatic cloud cover assessment (ACCA)
  algorithm and a decision tree based cloud detection approach. These bands
  provide information relevant to pixel reliability. Results downloaded from
  AppEEARS and/or data directly requested via middleware services contain the
  integer values and descriptions for each band associated with each pixel
  extracted.
  - See the WELD product documentation
  (https://lpdaac.usgs.gov/dataset_discovery/measures/measures_products_table)
  or Roy et al. 2010 (http://dx.doi.org/10.1016/j.rse.2009.08.011) for details
  regarding these bands.

 4.3 NASA MEaSUREs SRTM v3 (30m & 90m)
     ---------------------------------
  SRTM v3 products are accompanied by an ancillary "NUM" file in place of the
  QA/QC files. The "NUM" files indicate the source of each SRTM pixel, as well
  as the number of input data scenes used to generate the SRTM v3 data for that
  pixel.
  - See the user guide (https://lpdaac.usgs.gov/sites/default/files/
  public/measures/docs/NASA_SRTM_V3.pdf) for additional information regarding
  the SRTM "NUM" file.

 4.4 GPW v4
     ------
  The GPW Population Count and Population Density data layers are accompanied
  by two Data Quality Indicators datasets. The Data Quality Indicators were
  created to provide context for the population count and density grids, and to
  provide explicit information on the spatial precision of the input boundary
  data. The data context grid (data-context1) explains pixels with "0"
  population estimate in the population count and density grids, based on
  information included in the census documents. The mean administrative unit
  area grid (mean-admin-area2) measures the mean input unit size in square
  kilometers. It provides a quantitative surface that indicates the size of the
  input unit(s) from which the population count and density grids were created.

 4.5 S-NPP NASA VIIRS
     ----------------
  All S-NPP NASA VIIRS land products include quality information
  designed to help users understand and make best use of the data that comprise
  each product. For product-specific information, see the link to the S-NPP
  VIIRS products table provided in section 5.

  NOTE:
    - The S-NPP NASA VIIRS Surface Reflectance data products VNP09A1 and VNP09H1
    contain two quality layers: 'SurfReflect_State' and 'SurfReflect_QC'. Both
    quality layers are provided to the user with the request results. Due to changes
    implemented on August 21, 2017 for forward processed data, there are differences
    in values for the 'SurfReflect_QC' layer in VNP09A1 and 'SurfReflect_QC_500'
    in VNP09H1.
    - Refer to the S-NPP NASA VIIRS Surface Reflectance User's Guide Version 1.1
    (https://lpdaac.usgs.gov/sites/default/files/public/product_documentation/vnp09_user_guide.pdf)
    for information on how to decode the 'SurfReflect_QC' quality layer for data
    processed before August 21, 2017. For data processed on or after August 21, 2017,
    refer to the S-NPP NASA VIIRS Surface Reflectance User's guide Version 1.6
	(https://lpdaac.usgs.gov/sites/default/files/public/product_documentation/vnp09_user_guide_v1.6.pdf).

 4.6 SMAP
     ----
  SMAP products provide multiple means to assess quality. Each data product
  contains bit flags, uncertainty measures, and file-level metadata that provide
  quality information. Results downloaded from AppEEARS and/or data directly
  requested via middleware services contain not only the requested pixel/data
  values, but also the decoded bit flag information associated with each pixel/data
  value extracted. For additional information regarding the specific bit flags,
  uncertainty measures, and file-level metadata contained in this product, refer
  to the Quality Assessment section of the user guide for the specific SMAP data
  product in your request (https://nsidc.org/data/smap/smap-data.html).

5. Documentation
   -------------
The documentation for AppEEARS can be found at https://lpdaacsvc.cr.usgs.gov/appeears/help.

Documentation for data products available through AppEEARS are listed below.
 MODIS Land Products(Terra, Aqua, & Combined)
  - https://lpdaac.usgs.gov/dataset_discovery/modis/modis_products_table

 MODIS Snow Products (Terra and Aqua)
  - https://nsidc.org/data/modis/data_summaries

 NASA MEaSUREs Web Enabled Landsat Data (WELD) (CONUS & Alaska)
  - https://lpdaac.usgs.gov/dataset_discovery/measures/measures_products_table

 NASA MEaSUREs SRTM v3
  - https://lpdaac.usgs.gov/dataset_discovery/measures/measures_products_table

 GPW v4
  - http://sedac.ciesin.columbia.edu/binaries/web/sedac/collections/gpw-v4/gpw-v4-documentation.pdf

 S-NPP NASA VIIRS Land Products
  - https://lpdaac.usgs.gov/dataset_discovery/viirs/viirs_products_table

 SMAP Products
  - http://nsidc.org/data/smap/smap-data.html


6. Sample Request Retention
   ------------------------
AppEEARS sample request outputs are available to download for a limited amount of time after completion.
Please visit https://lpdaacsvc.cr.usgs.gov/appeears/help?section=sample-retention for details.


7. Data Product Citations
   ----------------------
 Schaaf, C., Wang, Z. (2015). MCD43A3 MODIS/Terra+Aqua BRDF/Albedo Daily L3 Global - 500m V006. NASA EOSDIS Land Processes DAAC. doi: 10.5067/MODIS/MCD43A3.006. Accessed September 19, 2018.
 

8. Feedback
   --------
We value your opinion. Please help us identify what works, what doesn't, and
anything we can do to make AppEEARS better by submitting your feedback at
https://lpdaacsvc.cr.usgs.gov/appeears/feedback or to LP DAAC User Services at
https://lpdaac.usgs.gov/user_services.
