library(dapClimates)
library(climates)
library(geoknife)
library(ncdf4)
library(parallel)
library(tools)

check_jobs<-function(jobs_list, completed_jobs, list_length) {
  while(length(jobs_list)>list_length)
  {
    # Check every two seconds
    Sys.sleep(2)
    # hacky indices. Names are too cumbersome.
    jinds<-c(); jind<-1
    # Loop over jobs and try to collect results.
    for(job in jobs_list){
      done<-mccollect(job, wait=FALSE)
      # If some results are ready.
      if(length(done)>0){
        # Print Status
        print(job$name)
        # Add result to list of results.
        done_jobs[length(completed_jobs)+1]<-done
        # Kill the job that completed. Can't believe I have to do this.
        pskill(job$pid)
        # Record job index for removal.
        jinds<-append(jind,jinds)
      }
      # Index job index
      jind<-jind+1
    }
    # Remove completed jobs from jobs list.
    jobs_list[jinds]<-NULL
  }
  return(list(jobs_list=jobs_list,completed_jobs=completed_jobs))
}

# Process Inputs
start <- "2006"
end <- "2099"
bbox_in<-c(-67,52.82,-124.65,25.1)
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

# Get list of datasets using GDP utility.
gk <- geoknife()
setProcessInputs(gk)<-list(DATASET_URI='http://cida.usgs.gov/thredds/dodsC/cmip5_bcca/future')
data<-getDataIDs(gk,cachedResponse=TRUE)
unique_data<-c()
for(da in data){
  if(grepl('_pr',da)){
    unique_data<-append(gsub('BCCA_0-125deg_pr_day_','',da),unique_data)
  }
}
# Note this dataset is local and remote.
OPeNDAP_URI<-'http://cida.usgs.gov/thredds/dodsC/cmip5_bcca/future'
OPeNDAP_URI<-'http://igsarmewwsdlb2.gs.doi.net:8080/thredds/dodsC/striped/bcca/bcca/cmip5_out/ncmls/unions/BCCA_0.125deg.rcp.ncml'
NetCDF_output=TRUE

# set output location
wd<-'~/temp/'

# Number of processes started will be one more than given.
parLevel<-1
# Step through jobs one scenario at a time.
jobs<-list()
done_jobs<-list()
for(data_id in unique_data[1:5])
{
  # Randomly sleep processes to avoid flooding data-store with requests while jobs are spinning up.
  if(length(jobs)<parLevel) Sys.sleep(60)
  # Make unique directory for output
  # set output location
  wd<-'~/temp/'
  dir.create(paste(wd,data_id,sep=''),showWarnings=FALSE)
  setwd(paste(wd,data_id,sep=''))
  # Set unique process inputs
  tmax_var<-paste('BCCA_0-125deg_tasmax_day_',data_id,sep='')
  tmin_var<-paste('BCCA_0-125deg_tasmin_day_',data_id,sep='')
  prcp_var<-paste('BCCA_0-125deg_pr_day_',data_id,sep='')
  tave_var<-NULL
  # Print some status
  print(paste('start', data_id,sep=' '))
  # mcparallel spins up a new R session with the current environment and executes a function.
  job<-mcparallel(dap_daily_stats(start, end, bbox_in, thresholds, OPeNDAP_URI, tmax_var, tmin_var, tave_var, prcp_var, NetCDF_output,fill_nas=TRUE),data_id)
  jobs[[length(jobs)+1]]<-job
  # Once the jobs list is long enough start checking for completion.
  if(length(jobs)>parLevel){
    # Check while the jobs list is full.
    te<-check_jobs(jobs,done_jobs,parLevel); te$jobs_list<-jobs; te$completed_jobs<-done_jobs
  }
}
# Once all jobs have been started, clean up as they finish.
te<-check_jobs(jobs,done_jobs,0); te$jobs_list<-jobs; te$completed_jobs<-done_jobs

