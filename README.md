BCCA CMIP5 Derivative Preparation
=================================

These scripts implement the climates R package. [**climates**](https://github.com/jjvanderwal/climates)
They also make use of pyGDP. [**pyGDP**](https://github.com/USGS-CIDA/pyGDP)  

Processing
----------
1. [derivatives_runner_local_cmip5.R](https://github.com/dblodgett-usgs/derivatives_runner/blob/master/derivatives_runner_local_cmip5.R) used to execute initial annual derivatives. Run once for future, once for historical.  
  * [Annual gridded output for future here.](http://cida.usgs.gov/thredds/catalog/cmip5_bcca/derivatives/cmip5_der/catalog.html) [Historical here.](http://cida.usgs.gov/thredds/catalog/cmip5_bcca/derivatives/cmip5_hist_der/catalog.html)
2. [ensembler.R](https://github.com/dblodgett-usgs/derivatives_runner/blob/master/ensembler.R) used to create ensemble data and maps. Ensemble content in links above.   
3. periodizer.R used to generate climatological summaries. Run once for future, once for historical.  
  * [Future here.](http://cida.usgs.gov/thredds/catalog/cmip5_bcca/derivatives/cmip5_der_periods/catalog.html) [Historical here.](http://cida.usgs.gov/thredds/catalog/cmip5_bcca/derivatives/cmip5_hist_der_periods/catalog.html) 
4. [differencer.R](https://github.com/dblodgett-usgs/derivatives_runner/blob/master/differencer.R) used to create difference maps content.  
  * [Content here.](http://cida.usgs.gov/thredds/catalog/cmip5_bcca/derivatives/cmip5_der_diff/catalog.html)
5. Run Geo Data Portal summarizations for annualized derivatives.  
  * [pyGDP_runner.py](https://github.com/dblodgett-usgs/derivatives_runner/blob/master/pyGDP_runner.py) used to execute runs in parallel against a localhost copy of the data and the GDP. GDP output converted to DSG with [write_dsg.R](https://github.com/dblodgett-usgs/derivatives_runner/blob/master/write_dsg.R)
  * [Content is here.](http://cida.usgs.gov/thredds/catalog/cmip5_bcca/derivatives/spatial/catalog.html) Note that the csv files are raw GDP output. The NetCDF content is in folders there.
  * [Shapefiles used are here.](http://cida.usgs.gov/thredds/catalog/cmip5_bcca/derivatives/shapefiles/catalog.html)

Service Configuration
---------------------
1. .ncml aggregations for all. [ncml_script.py](https://github.com/dblodgett-usgs/derivatives_runner/blob/master/ncml_script.py)
2. [Deploy on THREDDS.](http://cida.usgs.gov/thredds/catalog/cmip5_bcca/derivatives/catalog.html)
3. TODO: Configure ncWMS

Ensemble Summary
------------
Will be ensembling r1i1p1. Not all ensembles will include all GCMs/Scenarios.

| r1i1p1 | RCP26 | RCP45 | RCP60 | RCP85 | sum | hist |
| ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| ACCESS1-0 |  | 1 |  | 1 | 2 | 1 |
| bcc-csm1-1 | 1 | 1 | 1 | 1 | 4 | 1 |
| BNU-ESM |  | 1 |  | 1 | 2 | 1 |
| CanESM2 | 1 | 1 |  | 1 | 3 | 1 |
| CCSM4 | 1 | 1 | 1 | 1 | 4 | 1 |
| CESM1-BGC |  | 1 |  | 1 | 2 | 1 |
| CSIRO-Mk3-6-0 | 1 | 1 |  | 1 | 3 | 1 |
| GFDL-CM3 | 1 |  | 1 | 1 | 3 | 1 |
| GFDL-ESM2G | 1 | 1 | 1 | 1 | 4 | 1 |
| GFDL-ESM2M | 1 | 1 | 1 | 1 | 4 | 1 |
| inmcm4 |  | 1 |  | 1 | 2 | 1 |
| IPSL-CM5A-LR | 1 | 1 | 1 | 1 | 4 | 1 |
| IPSL-CM5A-MR | 1 | 1 | 1 | 1 | 4 | 1 |
| MIROC-ESM | 1 | 1 | 1 | 1 | 4 | 1 |
| MIROC-ESM-CHEM | 1 | 1 | 1 | 1 | 4 | 1 |
| MIROC5 | 1 | 1 | 1 | 1 | 4 | 1 |
| MPI-ESM-LR | 1 | 1 |  | 1 | 3 | 1 |
| MPI-ESM-MR | 1 | 1 |  | 1 | 3 | 1 |
| MRI-CGCM3 | 1 | 1 | 1 | 1 | 4 | 1 |
| NorESM1-M | 1 | 1 | 1 | 1 | 4 | 1 |
| sum | 16 | 19 | 12 | 20 | 13 |