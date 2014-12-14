library(ncdf4)
library(dapClimates)
library(climates)
library(snow)
data_path<-'/Volumes/Striped/bcca/cmip3_rewrite/'
setwd(data_path)
nc_files<-list.files(pattern='*.nc')
# nc_file<-nc_files[1]
# nc_file<-'cccma_cgcm3_1-gregorian-sresa1b-run1.nc'
start <- "2047"
end <- "2065"
# bbox_in<-c(-67.06,52.81,-124.6,25.18)
bbox_in<-c(-88,42,-89,43)
thresholds=list(days_tmax_abv_thresh=c(32.2222,35,37.7778),
                days_tmin_blw_thresh=c(-17.7778,-12.2222,0),
                days_prcp_abv_thresh=c(25.4,50.8,76.2,101.6),
                longest_run_tmax_abv_thresh=c(32.2222,35,37.7778),
                longest_run_prcp_blw_thresh=c(76.2),
                growing_degree_day_thresh=c(15.5556),
                heating_degree_day_thresh=c(18.3333),
                cooling_degree_day_thresh=c(18.3333),
                growing_season_lngth_thresh=c(0))
NetCDF_output<-TRUE
jobs<-list()
wd<-'~/temp/'
par_runner<-function(start, end, bbox_in, thresholds, nc_file, NetCDF_output, wd,data_path){
  library(dapClimates)
  library(climates)
  library(ncdf4)
  dir.create(paste(wd,gsub('.nc','',nc_file),set=''),showWarnings=FALSE)
  setwd(paste(wd,gsub('.nc','',nc_file),set=''))
  tmax_var<-paste(gsub('.nc','',nc_file),'-tasmax-BCCA_0-125deg',sep='')
  tmin_var<-paste(gsub('.nc','',nc_file),'-tasmin-BCCA_0-125deg',sep='')
  prcp_var<-paste(gsub('.nc','',nc_file),'-pr-BCCA_0-125deg',sep='')
  tave_var<-NULL
  fileNames<-dap_daily_stats(start,end,bbox_in,thresholds,nc_file,tmax_var,tmin_var,tave_var,prcp_var, NetCDF_output)
  return(fileNames)
}
cl <- makeCluster(c("localhost","localhost","localhost","localhost","localhost","localhost"), type = "SOCK")
parSapply(cl,nc_files,par_runner,start=start,end=end,bbox_in=bbox_in,thresholds=thresholds, NetCDF_output=NetCDF_output,wd=wd,data_path=data_path)
stopCluster(cl)
