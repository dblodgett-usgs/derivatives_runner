README for BCCA averaging


Overview
The python script "averageBCCA.py" contained in this repository enables averaging of the CMIP5 BCCA data (tmax, tmin, precip) over a given time frame (i.e., monthly, seasonal, or annual). The script is designed to ingest daily data from one of the many NetCDF files, which includes modeled historical and projected data output from the BCCA (downscaled) processing. and also observed gridded meteorological data. A description of the BCCA processing of CMIP5 data is beyond the scope here, however further documentation can be found at: http://gdo-dcp.ucllnl.org/downscaled_cmip_projections/#About


Seasonal averages
Averaging of the daily data over "seasons" starts with the user providing a source file (e.g., daily data from a given GCM or the gridded observations), a variable name (e.g., tasmax, tasmin, pr), a "period" (historical, future, or observed), a prefix for the resulting output file, and a path to the desired output folder. The order and a brief description are provided in the header of the averaging routine (averageBCCA.py), also provided here for clarity:

Arguments:
filename		-	The desired source file
varname			-	The variable to be used (tasmax, tasmin, pr)
period			-	The period of interest, either historical (hist), or future (rcp), or observed (new_gmo)
outfileprefix		-	The prefix of the resulting netCDF file
outfolder		-	The destination folder for output


The input of "period" controls the temporal range for the script (e.g., start and end dates). Given these temporal limits, the script marches through the daily data and calculates averages over 3-month periods including March through May, June through August, September through November, and December through February (where February is from the following year at a given year in the processing). The calculations are performed over these "time-windows" for each grid-point (e.g., latitude/longitude pair) in the source data.


Annual averages
Once the script has completed the calculation of seasonal averages for a given input file (e.g., one of the many GCM NetCDF files or the observed data), it then begins the calculation of annual averages. The steps are are similar to the seasonal calculations, with the key difference being the "chunks" of daily data are now used to calculate an average over the entire year for a given year.


Monthly averages
On the completion of the annual averaging, the script begins calculation of monthly averages. This step is identical to the annual calculations, with the key difference here being the "chunks" of daily data are used to calculate an average over the period of one month for a given month. 



 
