library(ncdf4)
library(climates)
library(snow)
library(chron) # Not sure this is needed.

# Set script constants
storage_root<-'/Volumes/Scratch/thredds/bcca/bcca/cmip5' # Where all the data will end up at rest.
out_path<-'/Volumes/Striped/' # Where data will get written to durring processing.
bbox_in<-c(-67.06,52.81,-124.6,25.18) # bbox of the data.

# Set up cluster.
cl <- makeCluster(rep('localhost',25), type = "SOCK")

# Run historical derivatives.
data_path<-paste(storage_root,path$historical_data_path,sep='')
wd<-paste(out_path,path$historical_path,sep='')
dir.create(wd, recursive = TRUE)
nc_files<-list.files(pattern=paste(data_path,'*.nc',sep=''))
start <- "1950"; end <- "2004"
parSapply(cl,nc_files,par_runner,start=start,end=end,bbox_in=bbox_in,
          thresholds=thresholds, NetCDF_output=TRUE, wd=wd, data_path=data_path)

# Run future derivatives.
data_path<-paste(storage_root,path$future_data_path,sep='')
wd<-paste(out_path,path$future_path,sep='')
dir.create(wd, recursive = TRUE)
nc_files<-list.files(pattern=paste(data_path,'*.nc',sep=''))
start <- "2006"; end <- "2099"
parSapply(cl,nc_files,par_runner,start=start,end=end,bbox_in=bbox_in,
          thresholds=thresholds, NetCDF_output=TRUE, wd=wd, data_path=data_path)

stopCluster(cl)

# Ensemble Historical Derivatives
data_path<-paste(out_path,path$historical_path,sep='')
setwd(data_path) # Might not need to do this?
gcm_scenarios<-list.dirs(data_path)
nc_file<-fileNames[1]
ensemble(nc_file, data_path, scenarios, gcm_scenarios, start, end)

# Ensemble Future Derivatives
data_path<-paste(out_path,path$future_path,sep='')
setwd(data_path) # Might not need to do this?
gcm_scenarios<-list.dirs(data_path)
nc_file<-fileNames[1]
ensemble(nc_file, data_path, scenarios, gcm_scenarios, start, end)

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

