library(ncdf4)
# Previously run derivatives.
# data_path<-'/Volumes/Scratch/thredds/bcca/bcca/cmip5/derivatives/cmip5_hist_der/'
data_path<-'/Volumes/Striped/temp/'
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
fileNames<-c()
for (stat in names(thresholds))
{
  varName<-gsub("_thresh","",stat)
  fileName<-paste(varName,'.nc',sep='')
  fileNames<-append(fileNames,fileName)
}
setwd(data_path); gcm_scenarios<-list.dirs()
for(gcm_scenario_ind in 2:length(gcm_scenarios)){
  gcm_scenario<-tail(unlist(strsplit(gcm_scenarios[gcm_scenario_ind],'/')),n=1)
  for(file in fileNames) {
    ncid<-nc_open(paste(data_path,gcm_scenario,'/',file,sep=''),write=TRUE)
    ncvar_put(ncid,'threshold',unlist(thresholds[gsub(".nc","_thresh",file)]))
    nc_close(ncid)
  }
}
