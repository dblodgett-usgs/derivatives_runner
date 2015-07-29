library(geoknife)
shapefiles<-c('derivative:CONUS_States','derivative:US_Counties','derivative:FWS_LCC',
						 'derivative:Level_III_Ecoregions','derivative:NCA_Regions','derivative:wbdhu8_alb_simp')
shapefile_ids<-c('STATE','FIPS','area_names','LEVEL3_NAM','NCA_Region','HUC_8')

dataURIs=c('http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/longest_run_tmax_abv_cmip5_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/longest_run_prcp_blw_cmip5_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/heating_degree_day_cmip5_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/growing_season_lngth_cmip5_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/growing_degree_day_cmip5_der.ncml.html',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/days_tmin_blw_cmip5_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/days_tmax_abv_cmip5_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/days_prcp_abv_cmip5_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/cooling_degree_day_cmip5_der.ncml'
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/longest_run_tmax_abv_cmip5_hist_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/longest_run_prcp_blw_cmip5_hist_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/heating_degree_day_cmip5_hist_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/growing_season_lngth_cmip5_hist_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/growing_degree_day_cmip5_hist_der.ncml.html',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/days_tmin_blw_cmip5_hist_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/days_tmax_abv_cmip5_hist_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/days_prcp_abv_cmip5_hist_der.ncml',
					'http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/cooling_degree_day_cmip5_hist_der.ncml')

remote_rep<-'http://cida.usgs.gov/thredds/dodsC/cmip5_bcca/derivatives/ncml/'
local_pattern<-"http://localhost:8080/thredds/dodsC/Striped/derivatives/ncml/"

GDP_Runner<-function(shapefile, shapefile_id, dataURI){
	remoteURI<-gsub(local_pattern,remote_rep,dataURI)
	stencil <- webgeom()
	geom(stencil) <- shapefile
	attribute(stencil) <- shapefile_id
	fabric<-webdata(url=remoteURI)
	variables(fabric)<-query(fabric,'variables')
	times(fabric)<-query(fabric,'times')
	knife <- webprocess()
	url(knife)<-"http://localhost:8080/gdp-process-wps/WebProcessingService"
	
}
	