#' Run dap_daily_stats for use with parSapply.
#' 
#' @param start A string start year
#' @param end A string end year
#' @param bbox_in a vector of bbox indices per dap_daily_stats
#' @param thresholds a list of thresholds per dap_daily_stats
#' @param nc_file the netcdf file or opendap endpoint to use
#' @param NetCDF_output defaults to TRUE, geotiff if FALSE
#' @param wd The working directory to put derived results
#' @param data_path The path where the data files can be found
#' @return fileNames the list of filenames that were created.
#' @export
#' 
par_runner<-function(start, end, bbox_in, thresholds, nc_file, NetCDF_output=TRUE, wd, data_path, sleep=10){
  library(climates)
  library(ncdf4)
  library(PCICt)
  Sys.sleep(sample(1:sleep,1))
  dir.create(file.path(wd,gsub('.nc','',nc_file)),showWarnings=FALSE)
  setwd(file.path(wd,gsub('.nc','',nc_file)))
  tmax_var<-paste('BCCA_0-125deg_tasmax_day_',gsub('.nc','',nc_file),sep='')
  tmin_var<-paste('BCCA_0-125deg_tasmin_day_',gsub('.nc','',nc_file),sep='')
  prcp_var<-paste('BCCA_0-125deg_pr_day_',gsub('.nc','',nc_file),sep='')
  tave_var<-NULL
  nc_file<-file.path(data_path,nc_file)
  fileNames<-dap_daily_stats(start,end,bbox_in,thresholds,nc_file,tmax_var,tmin_var,tave_var,prcp_var, NetCDF_output)
  return(fileNames)
}