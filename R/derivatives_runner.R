path<-list(
  obs_data_path='data/obs',
  historical_data_path='data/historical', # Where the raw historical data originates
  future_data_path='data/rcp', # Where the raw future data originates
  future_path='derivatives/cmip5_der', # Where the future derivatives get moved to.
  historical_path='derivatives/cmip5_hist_der', # Where the historical derivatives get moved to.
  obs_path='derivatives/cmip5_obs_der',
  historical_periods_path='derivatives/cmip5_hist_der_periods', # Where the historical periods go.
  obs_periods_path='derivatives/cmip5_obs_der_periods',
  future_periods_path='derivatives/cmip5_der_periods', # Where the future periods go.
  difference_path='derivatives/cmip5_der_diff') # Where the difference output gos.

thresholds=list(days_tmax_abv_thresh=c(32.2222,35,37.7778),
                days_tmin_blw_thresh=c(-17.7778,-12.2222,0),
                days_prcp_abv_thresh=c(25.4,50.8,76.2,101.6),
                longest_run_tmax_abv_thresh=c(32.2222,35,37.7778),
                longest_run_prcp_blw_thresh=c(3),
                growing_degree_day_thresh=c(15.5556),
                heating_degree_day_thresh=c(18.3333),
                cooling_degree_day_thresh=c(18.3333),
                growing_season_lngth_thresh=c(5))

p_units<-'mm/d'
t_units<-'C'

future_periods<-c(2011,2040,2070,2099)

historical_periods<-c(1961,1990)

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

nc_summary<-'This dataset was created through processing the BCCA V2 dataset with the climates R package and the USGS Geo Data Portal'
nc_date_create<-'2015-08-01'
nc_creator_name='David Blodgett'
nc_creator_email='dblodgett@usgs.gov'
nc_project='U.S. Geological Survey Geo Data Portal Climate Derivatives'
nc_proc_level='Downscaled climate indices sampled to polygon areas of interest'

subtract<-function(future,historical) {
  return(future-historical)
}

#' Main Function to Run Derivatives
#' 
#' @param storage_root The root of the raw data
#' @param out_root The root of the location to write the results to
#' @param bbox_in The bounding box to calculate derivatives on.
#' @param cpus The number of cpus to use when calculating derivatives
#' @export
#' 
derivatives_runner_fun<-function(storage_root, out_root, bbox_in, cpus) {
  # Set up cluster.
  cl <- makeCluster(rep('localhost',cpus), type = "SOCK")
  
  # Run obs derivatives.
  wd<-file.path(out_root,path$obs_path)
  dir.create(wd, recursive = TRUE)
  setwd(wd)
  tmax_var<-'tasmax'
  tmin_var<-'tasmin'
  prcp_var<-'pr'
  tave_var<-NULL
  nc_file<-'http://localhost:8080/thredds/dodsC/Scratch/thredds/new_gmo/GMO_w_meta.ncml'
  start <- "1950"
  end <- "2006"
  dap_daily_stats(start,end,bbox_in,thresholds,nc_file,tmax_var,tmin_var,tave_var,prcp_var, NetCDF_output=TRUE)
  
  # Run historical derivatives.
  data_path<-file.path(storage_root,path$historical_data_path)
  wd<-file.path(out_root,path$historical_path)
  print(wd)
  dir.create(wd, recursive = TRUE)
  nc_files<-list.files(data_path,pattern='*r1i1p1*')
  start <- "1950"
  end <- "2006"
  parSapply(cl,nc_files,par_runner,start=start,end=end,bbox_in=bbox_in,
            thresholds=thresholds, NetCDF_output=TRUE, wd=wd, data_path=data_path,sleep=(cpus*10))
  
  # Run future derivatives.
  data_path<-file.path(storage_root,path$future_data_path)
  wd<-file.path(out_root,path$future_path)
  print(wd)
  dir.create(wd, recursive = TRUE)
  nc_files<-list.files(data_path,pattern='*r1i1p1*')
  start <- "2006"
  end <- "2099"
  parSapply(cl,nc_files,par_runner,start=start,end=end,bbox_in=bbox_in,
            thresholds=thresholds, NetCDF_output=TRUE, wd=wd, data_path=data_path,sleep=(cpus*10))
  
  stopCluster(cl)
  
  # Ensemble Historical Derivatives
  data_path<-file.path(out_root,path$historical_path)
  start <- "1950"
  end <- "2004"
  ensemble(data_path, historical_scenarios, start, end)
  
  # Ensemble Future Derivatives
  data_path<-file.path(out_root,path$future_path)
  start <- "2006"
  end <- "2099"
  ensemble(data_path, future_scenarios, start, end)
  
  # Periodize Historical Derivatives
  data_path<-file.path(out_root,path$historical_path)
  out_path<-file.path(out_root,path$historical_periods_path)
  periodize(data_path, out_path, periods=historical_periods)
  
  # Perdiodize Future Derivatives
  data_path<-file.path(out_root,path$future_path)
  out_path<-file.path(out_root,path$future_periods_path)
  periodize(data_path, out_path, periods=future_periods)
  
  # Run Differences
  future_path<-file.path(out_root,path$future_periods_path)
  historical_path<-file.path(out_root,path$historical_periods_path)
  out_path<-file.path(out_root,path$difference_path)
  differencer(out_path, future_path, historical_path, future_periods)
}

