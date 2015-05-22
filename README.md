BCCA CMIP5 Derivative Preparation
=================================

There are two R packages that were used to generate derivatives that are calculated using the scripts here.  
**climates** https://github.com/jjvanderwal/climates  
**dapClimates** https://gitlab.cr.usgs.gov/dblodgett/dapclimates

Processing 
----------
1. derivatives_runner_local_cmip5.R used to execute initial annual derivatives. Run once for future, once for historical.
2. periodizer.R used to generate climatological summaries. Run once for future, once for historical
3. TODO: differencer.R used to create difference maps content.
4. TODO: Run Geo Data Portal summarizations for annualized derivatives.

Service Configuration
---------------------
1. TODO: .ncml aggregations for all.
2. TODO: Deploy on THREDDS
3. TODO: Configure ncWMS