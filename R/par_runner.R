par_runner<-function(start, end, bbox_in, thresholds, nc_file, NetCDF_output, wd,data_path){
  library(climates)
  library(ncdf4)
  Sys.sleep(sample(1:240,1))
  dir.create(paste(wd,gsub('.nc','',nc_file),sep='/'),showWarnings=FALSE)
  setwd(paste(wd,gsub('.nc','',nc_file),sep='/'))
  tmax_var<-paste('BCCA_0-125deg_tasmax_day_',gsub('.nc','',nc_file),sep='')
  tmin_var<-paste('BCCA_0-125deg_tasmin_day_',gsub('.nc','',nc_file),sep='')
  prcp_var<-paste('BCCA_0-125deg_pr_day_',gsub('.nc','',nc_file),sep='')
  tave_var<-NULL
  nc_file<-paste(data_path,nc_file,sep='')
  fileNames<-dap_daily_stats(start,end,bbox_in,thresholds,nc_file,tmax_var,tmin_var,tave_var,prcp_var, NetCDF_output)
  return(fileNames)
}