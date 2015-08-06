path<-list(
  historical_data_path='/data/historical/', # Where the raw historical data originates
  future_data_path='/data/future/', # Where the raw future data originates
  future_path='/derivatives/cmip5_der/', # Where the future derivatives get moved to.
  historical_path='/derivatives/cmip5_hist_der/', # Where the historical derivatives get moved to.
  historical_periods_path='/derivatives/cmip5_hist_der_periods/', # Where the historical periods go 
  future_periods_path='/derivatives/cmip5_der_periods/', # Where the future periods go.
  difference_path='/derivatives/cmip5_der_diff/') # Where the difference output gos.

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

future_periods<-c(2011,2040,2070,2099)

hustorical_periods<-c(1961,1990)

fileNames<-c() # fileNames is a list of the names we generate based on the thresholds list.
for (stat in names(thresholds))
{
  varName<-gsub("_thresh","",stat)
  fileName<-paste(varName,'.nc',sep='')
  fileNames<-append(fileNames,fileName)
}

gcms=c("ACCESS1-0","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC","CSIRO-Mk3-6-0","GFDL-CM3",
       "GFDL-ESM2G","GFDL-ESM2M","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC-ESM","MIROC-ESM-CHEM",
       "MIROC5","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M")

run="r1i1p1"

future_scenarios=c("rcp26","rcp45","rcp60","rcp85")

historical_scenarios=c("historical")

derivatives_runner_fun<-function(storage_root, out_path, bbox_in, cpus) {
  # Set up cluster.
  cl <- makeCluster(rep('localhost',cpus), type = "SOCK")
  
  # Run historical derivatives.
  data_path<-paste(storage_root,path$historical_data_path,sep='')
  wd<-file.path(out_path,path$historical_path)
  dir.create(wd, recursive = TRUE)
  nc_files<-list.files(pattern=paste(data_path,'*.nc',sep=''))
  start <- "1950"
  end <- "2004"
  parSapply(cl,nc_files,par_runner,start=start,end=end,bbox_in=bbox_in,
            thresholds=thresholds, NetCDF_output=TRUE, wd=wd, data_path=data_path)
  
  # Run future derivatives.
  data_path<-file.path(storage_root,path$future_data_path)
  wd<-file.path(out_path,path$future_path)
  dir.create(wd, recursive = TRUE)
  nc_files<-list.files(pattern=paste(data_path,'*.nc',sep=''))
  start <- "2006"
  end <- "2099"
  parSapply(cl,nc_files,par_runner,start=start,end=end,bbox_in=bbox_in,
            thresholds=thresholds, NetCDF_output=TRUE, wd=wd, data_path=data_path)
  
  stopCluster(cl)
  
  # Ensemble Historical Derivatives
  data_path<-file.path(out_path,path$historical_path)
  start <- "1950"
  end <- "2004"
  ensemble(data_path, historical_scenarios, start, end)
  
  # Ensemble Future Derivatives
  data_path<-file.path(out_path,path$future_path)
  start <- "2006"
  end <- "2099"
  ensemble(data_path, future_scenarios, start, end)
  
  # Periodize Historical Derivatives
  data_path<-paste(out_path,path$historical_path,sep='')
  setwd(data_path) # Might not need to do this?
  gcm_scenarios<-list.dirs(data_path) # Listing the folders that we generated derivatives into.
  out_path<-paste(out_path,path$historical_periods_path,sep='')
  periodize(gcm_scenarios, data_path, out_path, periods=historical_periods)
  
  # Perdiodize Future Derivatives
  data_path<-paste(out_path,path$future_path,sep='')
  setwd(data_path) # Might not need to do this?
  gcm_scenarios<-list.dirs(data_path) # Listing the folders that we generated derivatives into.
  out_path<-paste(out_path,path$future_periods_path,sep='')
  periodize(gcm_scenarios, data_path, out_path, periods=historical_periods)
  
  # Run Differences
  future_path<-paste(out_path,path$future_periods_path,sep='')
  historical_path<-paste(out_path,path$historical_periods_path,sep='')
  out_path<-paste(out_path,path$difference_path,sep='')
  setwd(future_path) # Don't need to do this?
  gcm_scenarios<-list.dirs(future_path)
}

