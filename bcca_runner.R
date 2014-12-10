library(dapClimates)
library(climates)
library(geoknife)
library(ncdf4)
library(parallel)
start <- "2080"
end <- "2099"
# bbox_in<-c(-67,53,-125,25)
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
NetCDF_output=TRUE
wd<-'~/temp/'
jobs<-list()
for(data_id in unique_data[1:10])
{
  Sys.sleep(sample(1:10)[1])
  dir.create(paste(wd,data_id,set=''),showWarnings=FALSE)
  setwd(paste(wd,data_id,set=''))
  tmax_var<-paste('BCCA_0-125deg_tasmax_day_',data_id,sep=''); tmin_var<-paste('BCCA_0-125deg_tasmin_day_',data_id,sep='')
  prcp_var<-paste('BCCA_0-125deg_pr_day_',data_id,sep=''); tave_var<-NULL
  job<-mcparallel(dap_daily_stats(start,end,bbox_in,thresholds,OPeNDAP_URI,tmax_var,tmin_var,tave_var,prcp_var, NetCDF_output),data_id)
  jobs[[length(jobs)+1]]<-job
  names(jobs)[[length(jobs)]]<-data_id
  if(length(jobs)>4){
    while(length(jobs)>5)
    {
      Sys.sleep(2)
      for(job in jobs){
        print(job$name)
        done<-mccollect(job, wait=FALSE)
      }
    }
  }
}
par_runner<-function(start, end, bbox_in, thresholds, OPeNDAP_URI, data_id, NetCDF_output, wd){
  library(dapClimates)
  library(climates)
  library(ncdf4)
  Sys.sleep(sample(1:60)[1])
  
  setwd(paste(wd,data_id,set=''))
  tmax_var<-paste('BCCA_0-125deg_tasmax_day_',data_id,sep=''); tmin_var<-paste('BCCA_0-125deg_tasmin_day_',data_id,sep='')
  prcp_var<-paste('BCCA_0-125deg_pr_day_',data_id,sep=''); tave_var<-NULL
  fileNames<-dap_daily_stats(start,end,bbox_in,thresholds,OPeNDAP_URI,tmax_var,tmin_var,tave_var,prcp_var, NetCDF_output)
  return(fileNames)
}
cl <- makeCluster(c("localhost","localhost","localhost","localhost","localhost","localhost"), type = "SOCK")
parSapply(cl,unique_data,par_runner,start=start,end=end,bbox_in=bbox_in,thresholds=thresholds,OPeNDAP_URI=OPeNDAP_URI, NetCDF_output=NetCDF_output,wd=wd)
stopCluster(cl)
