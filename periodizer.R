library(ncdf4)
library(dapClimates)
library(chron)

# Previously run derivatives.
data_path<-'/Users/dblodgett/temp/cmip5_der/'

# Where to write the results.
out_path<-'/Users/dblodgett/temp/cmip5_der_periods/'

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

# Generate filename list based on thresholds, note this logic is kinda redundant. See test below.
fileNames<-c()
for (stat in names(thresholds))
{
  varName<-gsub("_thresh","",stat)
  fileName<-paste(varName,'.nc',sep='')
  fileNames<-append(fileNames,fileName)
}

# Set working directory and get scenario names from it. Just being lazy here.
setwd(data_path); gcm_scenarios<-list.dirs()

# Will implement a loop over gcm_scenarios here. Should be 2:length(gcm_scenarios)
for(gcm_scenario_ind in 2:length(gcm_scenarios)){
  gcm_scenario<-tail(unlist(strsplit(gcm_scenarios[gcm_scenario_ind],'/')),n=1)
  
  #Use the first file for creation of the output ones.
  nc_file<-fileNames[1]
  # Create output directory and set it as the working directory.
  dir.create(paste(out_path,gcm_scenario,sep=''),showWarnings=FALSE); setwd(paste(out_path,gcm_scenario,sep=''))
  
  # Try and open the file.
  tryCatch(ncid <- nc_open(paste(data_path,gcm_scenario,'/',nc_file,sep='')), error = function(e) 
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
    ncid_in<-nc_open(paste(data_path,gcm_scenario,'/',file,sep=''))
    var_id<-unlist(strsplit(tail(unlist(strsplit(file,'/')),n=1),'[.]'))[1]
    var_data <- ncvar_get(ncid_in, varid=var_id)
    if(length(dim(var_data))==4) out_data<-array(1, dim=c(nrow(var_data),ncol(var_data),dim(var_data)[3],length(periods)-1))
    else out_data<-array(1, dim=c(nrow(var_data),ncol(var_data),length(periods)-1))
    for(per_ind in 1:(length(periods)-1)){
      li<-request_time_bounds(ncid_in,periods[per_ind],periods[per_ind+1])
      start_ind<-li$t_ind1; end_ind<-li$t_ind2; time_inds<-li$time
      if(length(dim(var_data))==4) out_data[,,,per_ind]<-round(apply(var_data[,,,start_ind:end_ind],c(1,2,3),mean, na.rm = TRUE),digits=2)
      else out_data[,,per_ind]<-round(apply(var_data[,,start_ind:end_ind], c(1,2), mean, na.rm = TRUE),digits=2)
    }
    out_data[is.nan(out_data)]<--1
    ncvar_put(ncid_out,var_id,out_data)
    ncvar_put(ncid_out,'threshold',ncvar_get(ncid_in,'threshold'))
    nc_close(ncid_in)
    nc_close(ncid_out)
  }
}








