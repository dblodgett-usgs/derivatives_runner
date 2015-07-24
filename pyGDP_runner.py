import pyGDP
pyGDP = pyGDP.pyGDPwebProcessing()
# shapefiles = pyGDP.getShapefiles()
# for shapefile in shapefiles:
#     if 'derivative:' in shapefile:
#         print shapefile
        # attributes = pyGDP.getAttributes(shapefile)
#         for attr in attributes:
#             print attr
#             
# shapefiles={'derivative:CONUS_States':'STATE',
#             'derivative:US_Counties':'FIPS',
#             'derivative:FWS_LCC':'area_names'}
shapefiles={'derivative:Level_III_Ecoregions':'LEVEL3_NAM',
            'derivative:NCA_Regions':'NCA_Region',
            'derivative:wbdhu8_alb_simp':'HUC_8'}
print shapefiles
# dataURIs=['http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/longest_run_tmax_abv_cmip5_der.ncml',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/longest_run_prcp_blw_cmip5_der.ncml',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/heating_degree_day_cmip5_der.ncml',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/growing_season_lngth_cmip5_der.ncml',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/growing_degree_day_cmip5_der.ncml.html',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/days_tmin_blw_cmip5_der.ncml',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/days_tmax_abv_cmip5_der.ncml',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/days_prcp_abv_cmip5_der.ncml',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/cooling_degree_day_cmip5_der.ncml']
          
dataURIs=['http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/longest_run_tmax_abv_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/longest_run_prcp_blw_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/heating_degree_day_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/growing_season_lngth_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/growing_degree_day_cmip5_hist_der.ncml.html',
          'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/days_tmin_blw_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/days_tmax_abv_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/days_prcp_abv_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/cooling_degree_day_cmip5_hist_der.ncml']

for dataURI in dataURIs:
    remote_dataURI=dataURI.replace('http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/','http://cida.usgs.gov/thredds/dodsC/cmip5_bcca/derivatives/ncml/')
    dataTypes = pyGDP.getDataType(remote_dataURI)
    timeRange = pyGDP.getTimeRange(remote_dataURI, dataTypes[1])
    for shapefile in shapefiles.keys():
        print shapefile
        print dataURI
        print dataTypes
        print timeRange
        print shapefiles[shapefile]
        shapefile.replace('derivative:','')
        outFile=pyGDP.submitFeatureWeightedGridStatistics(geoType=shapefile,
                                                              dataSetURI=dataURI,
                                                              varID=dataTypes,
                                                              startTime=timeRange[0],
                                                              endTime=timeRange[1],
                                                              attribute=shapefiles[shapefile],
                                                              coverage=False,
                                                              outputfname=shapefile.replace('derivative:','')+
                                                              #dataURI.replace('http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/','').replace('_cmip5_der.ncml','')+'.csv')
                                                              dataURI.replace('http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/','').replace('_cmip5_hist_der.ncml','')+'.csv')