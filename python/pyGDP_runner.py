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
            'derivative:CONUS_Climate_Divisions':'OBJECTID'}

# dataURIs=['http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/cmip5_obs_der/longest_run_tmax_abv.nc',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/cmip5_obs_der/longest_run_prcp_blw.nc',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/cmip5_obs_der/heating_degree_day.nc',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/cmip5_obs_der/growing_season_lngth.nc',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/cmip5_obs_der/growing_degree_day.nc',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/cmip5_obs_der/days_tmin_blw.nc',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/cmip5_obs_der/days_tmax_abv.nc',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/cmip5_obs_der/days_prcp_abv.nc',
#           'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/cmip5_obs_der/cooling_degree_day.nc']
          
dataURIs=["http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/averages_rcp/ncml/averages_annual.ncml",
          "http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/averages_rcp/ncml/averages_seasonal.ncml",
          "http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/averages_rcp/ncml/averages_monthly.ncml",
          "http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/averages_hist/ncml/averages_annual.ncml",
          "http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/averages_hist/ncml/averages_seasonal.ncml",
          "http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/averages_hist/ncml/averages_monthly.ncml",
          "http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/averages_gmo/ncml/averages_annual.ncml",
          "http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/averages_gmo/ncml/averages_seasonal.ncml",
          "http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/averages_gmo/ncml/averages_monthly.ncml"]

# dataURIs=['http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/longest_run_tmax_abv_cmip5_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/longest_run_prcp_blw_cmip5_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/heating_degree_day_cmip5_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/growing_season_lngth_cmip5_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/growing_degree_day_cmip5_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/days_tmin_blw_cmip5_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/days_tmax_abv_cmip5_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/days_prcp_abv_cmip5_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/cooling_degree_day_cmip5_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/longest_run_tmax_abv_cmip5_hist_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/longest_run_prcp_blw_cmip5_hist_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/heating_degree_day_cmip5_hist_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/growing_season_lngth_cmip5_hist_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/growing_degree_day_cmip5_hist_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/days_tmin_blw_cmip5_hist_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/days_tmax_abv_cmip5_hist_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/days_prcp_abv_cmip5_hist_der.ncml',
          # 'http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/cooling_degree_day_cmip5_hist_der.ncml']

for dataURI in dataURIs:
    remote_dataURI=dataURI.replace('http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/','http://cida-eros-thredds3.er.usgs.gov:8080/thredds/dodsC/cmip5_bcca/derivatives/')
    print(remote_dataURI)
    dataTypes = pyGDP.getDataType(remote_dataURI)
    timeRange = pyGDP.getTimeRange(remote_dataURI, dataTypes[0])
    if len(dataTypes)==1:
        dataTypes=dataTypes[0]
    for shapefile in shapefiles.keys():
        outputfilename=shapefile.replace('derivative:','')+'_'+dataURI.replace('http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/ncml/','')
        outputfilename=outputfilename.replace('http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/averages_rcp/ncml/','')
        outputfilename=outputfilename.replace('http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/averages_hist/ncml/','')
        outputfilename=outputfilename.replace('http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/averages_gmo/ncml/','')
        outputfilename=outputfilename.replace('http://localhost:8080/thredds/dodsC/Scratch/thredds/bcca/bcca/cmip5/derivatives/cmip5_obs_der/','')
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