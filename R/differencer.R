#' Difference periodized files between historical and past periods
#' 
#' @param nc_file the netcdf file or opendap endpoint to use
#' @param data_path The path where the data files can be found
#' @param future_path The path where the future periodized derivatives are
#' @param historical_path The path where the historical periodized derivatives are
#' @param periods The periods that were used in the periodizer
#' @export
#' 
differencer<-function(out_path, future_path, historical_path, periods) {
  gcm_scenarios<-list.dirs(future_path)
  # Loop over all GCM/Scenarios
  for(gcm_scenario_ind in 2:length(gcm_scenarios)){
    gcm_scenario<-tail(unlist(strsplit(gcm_scenarios[gcm_scenario_ind],'/')),n=1)
    
    #Use the first file for creation of the output ones.
    nc_file<-fileNames[1]
    # Create output directory and set it as the working directory.
    dir.create(file.path(out_path,gcm_scenario), showWarnings = FALSE, recursive = TRUE) 
    setwd(file.path(out_path,gcm_scenario))
    
    # Try and open the file.
    tryCatch(ncid <- nc_open(file.path(future_path,gcm_scenario,nc_file)), error = function(e) 
    {
      cat("An error was encountered trying to open the OPeNDAP resource."); print(e)
    })
    
    # Initialize the output NetCDF files.
    x_vals<-ncid$dim$lon$vals; y_vals<-ncid$dim$lat$vals
    li<-initialize_NetCDF(ncid, thresholds, start=FALSE, end=FALSE, tmax_var=FALSE, prcp_var=FALSE, x_vals, y_vals, periods, t_units, p_units)
    out_filenames<-li$fileNames
    
    # Make sure the in and out filenames are the same!
    stopifnot(any(out_filenames==fileNames))
    
    # Clean up
    nc_close(ncid)
    
    # Loop over fileNames
    for(file in out_filenames) {
      ncid_out<-nc_open(file,write=TRUE)
      ncid_future<-nc_open(file.path(future_path,gcm_scenario,file))
      ncid_hist<-nc_open(file.path(historical_path,gsub('rcp[0-9][0-9]','historical',gcm_scenario),file))
      
      # Extract the file name. This is actually the variable name.
      var_id<-unlist(strsplit(tail(unlist(strsplit(file,'/')),n=1),'[.]'))[1]
      var_data_future <- ncvar_get(ncid_future, varid=var_id)
      var_data_hist<-ncvar_get(ncid_hist,varid=var_id)
      
      # Create empty output data.
      if(length(dim(var_data_future))==4) {
        out_data<-array(1, dim=c(nrow(var_data_future),ncol(var_data_future),dim(var_data_future)[3],length(periods)-1))
      } else {
        out_data<-array(1, dim=c(nrow(var_data_future),ncol(var_data_future),length(periods)-1))
      }
      for(per_ind in 1:(length(periods)-1)){
        subtract<-function(future,historical) {
          return(future-historical)
        }
        if(length(dim(var_data_future))==4) {
          out_data<-apply(var_data_future, c(4), subtract, historical=var_data_hist)
        } else {
          out_data<-apply(var_data_future, c(3), subtract, historical=var_data_hist)
        }
      }
      out_data[is.nan(out_data)]<--1
      ncvar_put(ncid_out,var_id,out_data)
      ncvar_put(ncid_out,'threshold',ncvar_get(ncid_future,'threshold'))
      nc_close(ncid_future)
      nc_close(ncid_hist)
      nc_close(ncid_out)
    }
  }
}