#' Function to convert GDP output to NetCDF-DSG
#' 
#' @param gdp_output_root the path where gdp ouput gets dumped.
#' @export
#' 
write_dsg<-function(gdp_output_root){
  dirs<-list.dirs(gdp_output_root)
  for(dir in dirs[2:length(dirs)]) {
    setwd(file.path(gdp_output_root,dir))
    files<-list.files(pattern='*.ncml')
    for(file in files) {
      print(file)
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
            nc_file<-paste(varData$variable[1],'-',threshold,'.nc',sep='')
            nc_title<-paste(varData$variable[1],'threshold',threshold,sep=' ')
            attributes<-list(title = nc_title, summary = nc_summary, date_created=nc_date_create, 
                             creator_name=nc_creator_name,creator_email=nc_creator_email,
                             project=nc_project, processing_level=nc_proc_level)
            nc<-write_timeseries_dsg(nc_file, names(dsgData), lats, lons, time, dsgData, data_unit=threshData$units[1],	
                                     data_prec='integer', data_metadata=meta, attributes=attributes)
          }
        }
        dir.create('done', showWarnings = FALSE)
        file.rename(file, paste('done/',file,sep=''))
      }, error = function(e) {
        dir.create('bad', showWarnings = FALSE)
        file.rename(file, paste('bad/',file,sep=''))
        warning(paste(file, 'has a problem'))
      }
      )
    }
  }
}