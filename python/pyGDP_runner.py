import pyGDP
import os
import sys

pyGDP = pyGDP.pyGDPwebProcessing()
             
shapefiles={'derivative:CONUS_States':'STATE',
            'derivative:US_Counties':'FIPS',
            'derivative:FWS_LCC':'area_names',
            'derivative:Level_III_Ecoregions':'LEVEL3_NAM',
            'derivative:NCA_Regions':'NCA_Region',
            'derivative:wbdhu8_alb_simp':'HUC_8',
            'sample:CONUS_Climate_Divisions':'OBJECTID'}
          
dataURIs=['http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/longest_run_tmax_abv_cmip5_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/longest_run_prcp_blw_cmip5_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/heating_degree_day_cmip5_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/growing_season_lngth_cmip5_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/growing_degree_day_cmip5_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/days_tmin_blw_cmip5_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/days_tmax_abv_cmip5_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/days_prcp_abv_cmip5_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/cooling_degree_day_cmip5_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/longest_run_tmax_abv_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/longest_run_prcp_blw_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/heating_degree_day_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/growing_season_lngth_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/growing_degree_day_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/days_tmin_blw_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/days_tmax_abv_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/days_prcp_abv_cmip5_hist_der.ncml',
          'http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/cooling_degree_day_cmip5_hist_der.ncml']

for dataURI in dataURIs:
    remote_dataURI=dataURI.replace('http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/','http://cida.usgs.gov/thredds/dodsC/cmip5_bcca/derivatives/ncml/')
    dataTypes = pyGDP.getDataType(remote_dataURI)
    timeRange = pyGDP.getTimeRange(remote_dataURI, dataTypes[1])
    for shapefile in shapefiles.keys():
        outputfilename=shapefile.replace('derivative:','')+'_'+dataURI.replace('http://localhost:8080/thredds/dodsC/Striped/final_derivatives/derivatives/ncml/','')
        if not os.path.isfile(outputfilename):
            open(outputfilename, 'a').close()
            print shapefile
            print dataURI
            print dataTypes
            print timeRange
            print shapefiles[shapefile]
            outFile=pyGDP.submitFeatureWeightedGridStatistics(geoType=shapefile,
                                                                  dataSetURI=dataURI,
                                                                  varID=dataTypes,
                                                                  startTime=timeRange[0],
                                                                  endTime=timeRange[1],
                                                                  attribute=shapefiles[shapefile],
                                                                  coverage=False,
                                                                  outputfname=outputfilename)