library(dapClimates)
library(climates)
library(geoknife)
library(ncdf4)
library(snow)
start <- "2006"
end <- "2099"
bbox_in<-c(-67.06,52.81,-124.6,25.18)
# bbox_in<-c(-88,42,-89,43)
thresholds=list(days_tmax_abv_thresh=c(32.2222,35,37.7778),
                days_tmin_blw_thresh=c(-17.7778,-12.2222,0),
                days_prcp_abv_thresh=c(25.4,50.8,76.2,101.6),
                longest_run_tmax_abv_thresh=c(32.2222,35,37.7778),
                longest_run_prcp_blw_thresh=c(76.2),
                growing_degree_day_thresh=c(15.5556),
                heating_degree_day_thresh=c(18.3333),
                cooling_degree_day_thresh=c(18.3333),
                growing_season_lngth_thresh=c(0))
gk <- geoknife()
setProcessInputs(gk)<-list(DATASET_URI='http://cida.usgs.gov/thredds/dodsC/cmip5_bcca/future')
data<-getDataIDs(gk,cachedResponse=TRUE)
unique_data<-c()
for(da in data){
  if(grepl('_pr',da)){
    unique_data<-append(gsub('BCCA_0-125deg_pr_day_','',da),unique_data)
  }
}
OPeNDAP_URI<-'http://igsarmewwsdlb2.gs.doi.net:8080/thredds/dodsC/striped/bcca/bcca/cmip5_out/ncmls/unions/BCCA_0.125deg.rcp.ncml'
tmax_var  <- "BCCA_0-125deg_tasmax_day_ACCESS1-0_rcp45_r1i1p1"
tmin_var <- "BCCA_0-125deg_tasmin_day_ACCESS1-0_rcp45_r1i1p1"
prcp_var <- "BCCA_0-125deg_pr_day_ACCESS1-0_rcp45_r1i1p1"
tave_var <- NULL
NetCDF_output=TRUE
wd<-'~/temp/'
par_runner<-function(start, end, bbox_in, thresholds, OPeNDAP_URI, data_id, NetCDF_output, wd){
  library(dapClimates)
  library(climates)
  library(ncdf4)
  dir.create(paste(wd,data_id,set=''),showWarnings=FALSE)
  setwd(paste(wd,data_id,set=''))
  tmax_var<-paste('BCCA_0-125deg_tasmax_day_',data_id,sep=''); tmin_var<-paste('BCCA_0-125deg_tasmin_day_',data_id,sep='')
  prcp_var<-paste('BCCA_0-125deg_pr_day_',data_id,sep=''); tave_var<-NULL
  fileNames<-dap_daily_stats(start,end,bbox_in,thresholds,OPeNDAP_URI,tmax_var,tmin_var,tave_var,prcp_var, NetCDF_output)
  return(fileNames)
}
cl <- makeCluster(c("localhost","localhost"), type = "SOCK")
parSapply(cl,unique_data,par_runner,start=start,end=end,bbox_in=bbox_in,thresholds=thresholds,OPeNDAP_URI=OPeNDAP_URI, NetCDF_output=NetCDF_output,wd=wd)
stopCluster(cl)
