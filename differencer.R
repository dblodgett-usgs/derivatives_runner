library(climates)
library(ncdf4)
# Takes periodized derivatives and a single historical period and generates difference grids.

# Previously run derivatives.
future_path<-'~/temp/derivatives/cmip5_der_periods/'
historical_path<-'~/temp/derivatives/cmip5_hist_der_periods/'

out_path<-'~/temp/derivatives/cmip5_der_diff/'

# Thresholds used with previously run derivatives.
thresholds=list(days_tmax_abv_thresh=c(32.2222,35,37.7778),
                days_tmin_blw_thresh=c(-17.7778,-12.2222,0),
                days_prcp_abv_thresh=c(25.4,50.8,76.2,101.6),
                longest_run_tmax_abv_thresh=c(32.2222,35,37.7778),
                longest_run_prcp_blw_thresh=c(76.2),
                growing_degree_day_thresh=c(15.5556),
                heating_degree_day_thresh=c(18.3333),
                cooling_degree_day_thresh=c(18.3333),
                growing_season_lngth_thresh=c(0))

# Units from previously run derivatives.
p_units<-'mm/d'
t_units<-'C'

# Periods that will be used. These should include n+1 values where n is the number 
# of actual time steps desired. The last vaue should be the end of the final time step.
periods<-c(2011,2040,2070,2099)
hist_periods<-c(1961,1990)

# Generate filename list based on thresholds, note this logic is kinda redundant. See test below.
fileNames<-c()
for (stat in names(thresholds))
{
  varName<-gsub("_thresh","",stat)
  fileName<-paste(varName,'.nc',sep='')
  fileNames<-append(fileNames,fileName)
}

# Set working directory and get scenario names from it. Just being lazy here.
setwd(future_path); gcm_scenarios<-list.dirs()

# Loop over all GCM/Scenarios
for(gcm_scenario_ind in 2:length(gcm_scenarios)){
  gcm_scenario<-tail(unlist(strsplit(gcm_scenarios[gcm_scenario_ind],'/')),n=1)
  
  #Use the first file for creation of the output ones.
  nc_file<-fileNames[1]
  # Create output directory and set it as the working directory.
  dir.create(paste(out_path,gcm_scenario,sep=''),showWarnings=FALSE); setwd(paste(out_path,gcm_scenario,sep=''))
  
  # Try and open the file.
  tryCatch(ncid <- nc_open(paste(future_path,gcm_scenario,'/',nc_file,sep='')), error = function(e) 
  {
    cat("An error was encountered trying to open the OPeNDAP resource."); print(e)
  })
  
  # Initialize the output NetCDF files.
  x_vals<-ncid$dim$lon$vals; y_vals<-ncid$dim$lat$vals
  li<-initialize_NetCDF(ncid, thresholds, start=FALSE, end=FALSE, tmax_var=FALSE, prcp_var=FALSE, x_vals, y_vals, periods, t_units, p_units)
  out_filenames<-li$fileNames
  
  # Make sure the in and out filenames are the same!
  stopifnot(any(out_filenames==fileNames))
  
  # Clean up
  nc_close(ncid)
  
  # Loop over fileNames
  for(file in out_filenames) {
    ncid_out<-nc_open(file,write=TRUE)
    ncid_future<-nc_open(paste(future_path,gcm_scenario,'/',file,sep=''))
    ncid_hist<-nc_open(paste(historical_path,gsub('rcp[0-9][0-9]','historical',gcm_scenario),'/',file,sep=''))
    
    # Extract the file name. This is actually the variable name.
    var_id<-unlist(strsplit(tail(unlist(strsplit(file,'/')),n=1),'[.]'))[1]
    var_data_future <- ncvar_get(ncid_future, varid=var_id)
    var_data_hist<-ncvar_get(ncid_hist,varid=var_id)
    
    # Create empty output data.
    if(length(dim(var_data_future))==4) {
      out_data<-array(1, dim=c(nrow(var_data_future),ncol(var_data_future),dim(var_data_future)[3],length(periods)-1))
    } else {
      out_data<-array(1, dim=c(nrow(var_data_future),ncol(var_data_future),length(periods)-1))
    }
    for(per_ind in 1:(length(periods)-1)){
#       li<-request_time_bounds(ncid_future,periods[per_ind],periods[per_ind+1])
#       start_ind<-li$t_ind1
#       end_ind<-li$t_ind2
      subtract<-function(future,historical) {
        return(future-historical)
      }
      if(length(dim(var_data_future))==4) {
        out_data<-apply(var_data_future, c(4), subtract, historical=var_data_hist)
      } else {
        out_data<-apply(var_data_future, c(3), subtract, historical=var_data_hist)
      }
    }
  }
}