BCCA CMIP5 Derivative Preparation
=================================

These scripts implement the climates R package. [**climates**](https://github.com/jjvanderwal/climates)
They also make use of pyGDP. [**pyGDP**](https://github.com/USGS-CIDA/pyGDP)  

Package Description
-------------------
This package was used to orchestrate processing of derived climate indices based on the BCCA CMIP5 downscaled climate data. The main.R script is where environment specific paths go and calls to python scripts are documented. The R package encoded here is used to go from daily gridded climate projections to annual climate indices. The annual climate indices are then ensembled together, climatalogical summaries are calculated, and historical-future difference summaries are generated. These calculations are orchestrated by the code in derivatives\_runner.R.  

With the derivative content created, a pair of python scripts are used against a localhost instance of the USGS Geo Data Portal and a THREDDS data server. Prior to calling those scripts, a script that generates .ncml aggregations for the data is run for the derivatives.

Service Configuration
---------------------


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