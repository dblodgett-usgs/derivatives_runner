BCCA CMIP5 Derivative Preparation
=================================

There are two R packages that were used to generate derivatives that are calculated using the scripts here.  
**climates** https://github.com/jjvanderwal/climates  
**dapClimates** https://gitlab.cr.usgs.gov/dblodgett/dapclimates

Processing 
----------
1. derivatives_runner_local_cmip5.R used to execute initial annual derivatives. Run once for future, once for historical.
2. ensembler.R used to create ensemble data and maps.
3. periodizer.R used to generate climatological summaries. Run once for future, once for historical
4. differencer.R used to create difference maps content.
5. TODO: Run Geo Data Portal summarizations for annualized derivatives.

Service Configuration
---------------------
1. TODO: .ncml aggregations for all.
2. Deploy on THREDDS
3. TODO: Configure ncWMS

Organization
------------
Will be ensembling r1i1p1. Not all ensembles will include all GCMs/Scenarios.

| r1i1p1 | RCP26 | RCP45 | RCP60 | RCP85 | sum | hist |
| ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| ACCESS1-0 |  | 1 |  | 1 | 2 | 1 |
| bcc-csm1-1 | 1 | 1 | 1 | 1 | 4 |  |
| BNU-ESM |  | 1 |  | 1 | 2 | 1 |
| CanESM2 | 1 | 1 |  | 1 | 3 |  |
| CCSM4 | 1 | 1 | 1 | 1 | 4 | 1 |
| CESM1-BGC |  | 1 |  | 1 | 2 |  |
| CSIRO-Mk3-6-0 | 1 | 1 |  | 1 | 3 | 1 |
| GFDL-CM3 | 1 |  | 1 | 1 | 3 |  |
| GFDL-ESM2G | 1 | 1 | 1 | 1 | 4 | 1 |
| GFDL-ESM2M | 1 | 1 | 1 | 1 | 4 |  |
| inmcm4 |  | 1 |  | 1 | 2 | 1 |
| IPSL-CM5A-LR | 1 | 1 | 1 | 1 | 4 | 1 |
| IPSL-CM5A-MR | 1 | 1 | 1 | 1 | 4 | 1 |
| MIROC-ESM | 1 | 1 | 1 | 1 | 4 | 1 |
| MIROC-ESM-CHEM | 1 | 1 | 1 | 1 | 4 |  |
| MIROC5 | 1 | 1 | 1 | 1 | 4 | 1 |
| MPI-ESM-LR | 1 | 1 |  | 1 | 3 | 1 |
| MPI-ESM-MR | 1 | 1 |  | 1 | 3 | 1 |
| MRI-CGCM3 | 1 | 1 | 1 | 1 | 4 | 1 |
| NorESM1-M | 1 | 1 | 1 | 1 | 4 |  |
| sum | 16 | 19 | 12 | 20 | 13 |