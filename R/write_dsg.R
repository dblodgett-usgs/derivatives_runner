#' Function to convert GDP output to NetCDF-DSG
#' 
#' @param gdp_output_root the path where gdp ouput gets dumped.
#' @export
#' 
write_dsg<-function(gdp_output_root, cpus=1){
  dirs<-list.dirs(gdp_output_root,recursive = FALSE)
  files<-c()
  for(dir in dirs){
    files<-c(files,list.files(path = dir, pattern = '*.ncml',full.names = TRUE))
    print(dir)
    dir.create(file.path(dir,'nc'))
  }
  if (cpus>1){
    # Set up cluster.
    cl <- makeCluster(rep('localhost',cpus), type = "SOCK")
    parSapply(cl,X = files,FUN = parWriteDSG)
    stopCluster(cl)
  } else {
    sapply(files,parWriteDSG)
  }
}

parWriteDSG<-function(file) {
  library(netcdf.dsg)
  library(ncdf4)
  library(derivativesRunner)
  tryCatch({
    data<-parseTimeseries(file,',',TRUE)
    vars<-unique(data$variable)
    for(var in vars) {
      varData<-data[data$variable %in% var,]
      
      # !!!!!! Placeholder
      lats<-rep(0,length(names(varData[2:(ncol(varData)-4)])))
      lons<-lats
      # !!!!!! Placeholder
      
      long_name<-paste(varData$variable[1], 'area weighted', varData$statistic[1], 'in', varData$units[1], sep=' ')
      meta<-list(name=varData$variable[1],long_name=long_name)
      thresholds<-unique(varData$threshold)
      for(threshold in thresholds) {
        threshold<-thresholds[1]
        threshData<-varData[varData$threshold %in% threshold,]
        time<-threshData$DateTime
        dsgData<-threshData[2:(ncol(threshData)-4)]
        threshold<-round(as.double(threshold),digits = 2)
        nc_file<-file.path(dirname(file),'nc',paste(varData$variable[1],'-',threshold,'.nc',sep=''))
        print(nc_file)
        nc_title<-paste(varData$variable[1],'threshold',threshold,sep=' ')
        attributes<-list(title = nc_title, summary = nc_summary, date_created=nc_date_create, 
                         creator_name=nc_creator_name,creator_email=nc_creator_email,
                         project=nc_project, processing_level=nc_proc_level)
        nc<-write_timeseries_dsg(nc_file, names(dsgData), lats, lons, time, dsgData, data_unit=threshData$units[1],	
                                 data_prec='integer', data_metadata=meta, attributes=attributes)
      }
    }
    dir.create(file.path(dirname(file),'done'), showWarnings = FALSE)
    file.rename(file, file.path(dirname(file),'done',basename(file)))
  }, error = function(e) {
    dir.create(file.path(dirname(file),'bad'), showWarnings = FALSE)
    file.rename(file, file.path(dirname(file),'bad',basename(file)))
    warning(paste(file, 'has a problem'))
  }
  )
}