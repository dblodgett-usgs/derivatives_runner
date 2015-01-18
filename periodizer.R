library(ncdf4)
library(dapClimates)
library(chron)

data_path<-'/Users/dblodgett/temp/cmip5_der/'
out_path<-'/Users/dblodgett/temp/cmip5_der_periods/'
thresholds=list(days_tmax_abv_thresh=c(32.2222,35,37.7778),
                days_tmin_blw_thresh=c(-17.7778,-12.2222,0),
                days_prcp_abv_thresh=c(25.4,50.8,76.2,101.6),
                longest_run_tmax_abv_thresh=c(32.2222,35,37.7778),
                longest_run_prcp_blw_thresh=c(76.2),
                growing_degree_day_thresh=c(15.5556),
                heating_degree_day_thresh=c(18.3333),
                cooling_degree_day_thresh=c(18.3333),
                growing_season_lngth_thresh=c(0))

p_units<-'mm/d'
t_units<-'C'

periods<-c(2011,2040,2070,2100)

fileNames<-c()
for (stat in names(thresholds))
{
  varName<-gsub("_thresh","",stat)
  fileName<-paste(varName,'.nc',sep='')
  fileNames<-append(fileNames,fileName)
}

setwd(data_path)
gcm_scenarios<-list.dirs()

# Loop over gcm_scenarios
gcm_scenario<-tail(unlist(strsplit(gcm_scenarios[2],'/')),n=1)

#Use the first file for creation of the output ones.
nc_file<-fileNames[1]
dir.create(paste(out_path,gcm_scenario,sep=''),showWarnings=FALSE)
setwd(paste(out_path,gcm_scenario,sep=''))
OPeNDAP_URI<-paste(data_path,gcm_scenario,'/',nc_file,sep='')
tryCatch(ncid <- nc_open(OPeNDAP_URI), error = function(e) 
{
  cat("An error was encountered trying to open the OPeNDAP resource."); print(e)
})
x_vals<-ncid$dim$lon$vals
y_vals<-ncid$dim$lat$vals
li<-initialize_NetCDF(ncid, thresholds, start=FALSE, end=FALSE, tmax_var=FALSE, prcp_var=FALSE, x_vals, y_vals, periods, t_units, p_units)
out_filenames<-li$fileNames
# Should probably make sure the in and out filenames are the same!
# if(any(out_filenames!=fileNames)) 

# Loop over fileNames


var_id<-unlist(strsplit(tail(unlist(strsplit(nc_file,'/')),n=1),'[.]'))[1]

var_data <- ncvar_get(ncid, varid=var_id, start=c(1,1,1,1), count=c(-1,-1,-1,-1))

li<-request_time_bounds(ncid,'2011','2040')
start_ind<-li$t_ind1
end_ind<-li$t_ind2
time_inds<-li$time


