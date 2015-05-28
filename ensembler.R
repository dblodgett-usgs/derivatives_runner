library(ncdf4)
library(dapClimates)

# Previously run derivatives.
# data_path<-'/Users/dblodgett/temp/cmip5_der/'
data_path<-'/Volumes/Scratch/thredds/bcca/bcca/cmip5/derivatives/cmip5_der/'

gcms=("ACCESS1-0","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC","CSIRO-Mk3-6-0","GFDL-CM3",
"GFDL-ESM2G","GFDL-ESM2M","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC-ESM","MIROC-ESM-CHEM",
"MIROC5","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M")

run="r1i1p1"

scenarios=c("rcp26","rcp45","rcp60","rcp85")

# Thresholds used with previously run derivatives.
thresholds=list(days_tmax_abv_thresh=c(32.2222,35,37.7778),
                days_tmin_blw_thresh=c(-17.7778,-12.2222,0),
                days_prcp_abv_thresh=c(25.4,50.8,76.2,101.6),
                longest_run_tmax_abv_thresh=c(32.2222,35,37.7778),
                longest_run_prcp_blw_thresh=c(76.2),
                growing_degree_day_thresh=c(15.5556),
                heating_degree_day_thresh=c(18.3333),
                cooling_degree_day_thresh=c(18.3333),
                growing_season_lngth_thresh=c(0))

# Units from previously run derivatives.
p_units<-'mm/d'
t_units<-'C'

# Set working directory and get GCM/scenario names from it. Just being lazy here.
setwd(data_path); gcm_scenarios<-list.dirs()

# Generate filename list based on thresholds, note this logic is kinda redundant. See test below.
fileNames<-c()
for (stat in names(thresholds))
{
  varName<-gsub("_thresh","",stat)
  fileName<-paste(varName,'.nc',sep='')
  fileNames<-append(fileNames,fileName)
}

#Use the first file for creation of the output ones.
nc_file<-fileNames[1]

# Create output directory and set it as the working directory.
# This loop is done once for each ensemble we are creating.
for(scenario in scenarios)
{
  dir.create(paste(data_path,'ensemble_',scenario,sep=''),showWarnings=FALSE); setwd(paste(data_path,'ensemble_',scenario,sep=''))
  # Try and open the file.
  tryCatch(ncid <- nc_open(paste(data_path,gcm_scenarios[2],'/',nc_file,sep='')), error = function(e) 
  {
    cat("An error was encountered trying to open the OPeNDAP resource."); print(e)
  })
  
  # Initialize the output NetCDF files.
  x_vals<-ncid$dim$lon$vals; y_vals<-ncid$dim$lat$vals
  li<-initialize_NetCDF(ncid, thresholds, start="2006", end="2099", tmax_var=FALSE, prcp_var=FALSE, x_vals, y_vals, periods=FALSE, t_units, p_units)
  out_filenames<-li$fileNames
  
  # Make sure the in and out filenames are the same!
  stopifnot(any(out_filenames==fileNames))
  
  # Clean up
  nc_close(ncid)
  
  # Need to loop over input gcm_scenarios for each of the derivatives. Add values to what's already in as data is read in then divide and write out at the end.
  for(file in out_filenames) {
    # Extract the file name. This is actually the variable name for this file.
    var_id<-unlist(strsplit(tail(unlist(strsplit(file,'/')),n=1),'[.]'))[1]
    input<-1
    # Open the file we will be writing to.
    ncid_out<-nc_open(file,write=TRUE)
    for(gcm_scenario_ind in 2:length(gcm_scenarios)){
      gcm_scenario<-tail(unlist(strsplit(gcm_scenarios[gcm_scenario_ind],'/')),n=1)
      if(grepl('r1i1p1', gcm_scenario) && grepl(scenario,gcm_scenario))
      {
        print(gcm_scenario)
        # Open the file we need to add to the existing stuff.
        ncid_in<-nc_open(paste(data_path,gcm_scenario,'/',file,sep=''))
        # Get the data we need.
        var_data <- ncvar_get(ncid_in, varid=var_id)
        if (input==1)
        {
          ens_data<-var_data
          input<-input+1
        }
        else
        {
          ens_data<-ens_data+var_data
          intput<-input+1
        }
        nc_close(ncid_in) 
      }
    }
    # Get the thresholds we need. and put them in the output file.
    ncid_in<-nc_open(paste(data_path,gcm_scenario,'/',file,sep=''))
    ncvar_put(ncid_out,'threshold',ncvar_get(ncid_in,'threshold'))
    nc_close(ncid_in)
    # put the ensemble data in the output file.
    ens_data[is.nan(ens_data)]<--1
    print('output')
    ens_data<-ens_data/input
    ncvar_put(ncid_out,var_id,ens_data)
    nc_close(ncid_out)
  }
}
