import pyGDP
pyGDP = pyGDP.pyGDPwebProcessing()
# shapefiles = pyGDP.getShapefiles()
# for shapefile in shapefiles:
#     if 'derivative:' in shapefile:
#         print shapefile
#         attributes = pyGDP.getAttributes(shapefile)
#         for attr in attributes:
#             print attr
shapefiles={'derivative:CONUS_States':'STATE',
            'derivative:US_Counties':'FIPS',
            'derivative:FWS_LCC':'area_names',
            'derivative:Level_III_Ecoregions':'LEVEL3_NAM',
            'derivative:NCA_Regions':'NCA_Region',
            'derivative:wbdhu8_alb_simp':'HUC_8'}
print shapefiles
dataURI='http://cida.usgs.gov/thredds/dodsC/cmip5_bcca/derivatives/cmip5_der.ncml'
dataTypes = pyGDP.getDataType(dataURI)
timeRange = pyGDP.getTimeRange(dataURI, dataTypes[1])
for shapefile in shapefiles.keys():
    print shapefile
    print dataURI
    print dataTypes
    print timeRange
    print shapefiles[shapefile]
    shapefile.replace('derivative:','')
    # outFile=pyGDP.submitFeatureWeightedGridStatistics(geoType=shapefile,
    #                                                       dataSetURI=dataURI,
    #                                                       varID=dataTypes,
    #                                                       startTime=timeRange[1],
    #                                                       endTime=timeRange[1],
    #                                                       attribute=shapefiles[shapefile],
    #                                                       coverage=False,
    #                                                       outputfname=shapefile.replace('derivative:',''))
    #     break