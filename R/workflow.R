library(ncdf4)
library(climates)
library(snow)

# Set script constants
storage_root<-'/Volumes/Scratch/thredds/bcca/bcca/cmip5' # Where all the data will end up at rest.
out_path<-'/Volumes/Striped/' # Where data will get written to durring processing.
bbox_in<-c(-67.06,52.81,-124.6,25.18) # bbox of the data.

# Set up cluster.
cl <- makeCluster(rep('localhost',25), type = "SOCK")

# Run historical derivatives.
data_path<-paste(storage_root,path$historical_data_path,sep='')
wd<-paste(out_path,path$hist_path,sep='')
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