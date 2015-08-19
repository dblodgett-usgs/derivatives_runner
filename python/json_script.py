import os
import sys
import re

if os.path.isdir(sys.argv[1]):
    os.chdir(sys.argv[1])
else:
    sys.exit('You have to pass in a path')
    
wd=sys.argv[1]
sosRoot=sys.argv[2] # like http://cida-eros-derivativedev.er.usgs.gov:8080/thredds/sos/bcca/sos/
wmsRoot=sys.argv[3] # like http://cida-eros-derivativedev.er.usgs.gov:8080/thredds/wms/bcca/wms/

derivatives={"cooling_degree_day.nc":["cooling_degree_days","Cooling Degree Days"],
            "days_tmax_abv.nc":["days_with_tmax_above","Days with Tmax Above"],
            "growing_degree_day.nc":["growing_degree_days","Growing Degree Days"],
            "heating_degree_day.nc":["heating_degree_days","Heating Degree Days"],
            "longest_run_tmax_abv.nc":["longest_run_with_tmax_above","Longest Run with Tmax Above"],
            "days_prcp_abv.nc":["days_with_precip_above","Days with Precip Above"],
            "days_tmin_blw.nc":["days_with_tmin_below","Days with Tmin Below"],
            "growing_season_lngth.nc":["growing_season_length","Growing Season Length"],
            "longest_run_prcp_blw.nc":["longest_run_with_precip_below","Longest Run with Precip Below"]}            

scenarios={"rcp26":"RCP85","rcp45":"RCP45","rcp60":"RCP60","rcp85":"RCP85"}

folders=["cmip5_der_periods","cmip5_der_diff"]
folder=folders[0]
gcms=os.listdir(os.path.join(wd,'../',folder))
for derivative in derivatives.keys():
    deriv=derivatives[derivative][0]
    w=open(os.path.join(wd,deriv+'.json'),'w')
    w.write('[\n')
    w.write('   {\n')
    w.write('       "identifier" : "'+deriv+'",\n')
    w.write('       "descriptiveKeywords" : {\n')
    w.write('           "derivatives" : [\n')
    w.write('               "'+derivatives[derivative][1]+'"\n')
    w.write('           ],\n')
    w.write('           "scenarios" : [\n')
    for i, scenario in enumerate(scenarios.keys()):
        if i != (len(scenarios.keys())-1):
            w.write('               "'+scenarios[scenario]+'",\n')
        else:
            w.write('               "'+scenarios[scenario]+'"\n')
    w.write('           ],\n')
    w.write('		    "gcm" : [\n')
    gcm_list=[]
    for i, gcm in enumerate(gcms):
        if not gcm.startswith('.'):
            if 'ensemble' in gcm:
                stName=re.sub('_rcp..','',gcm)
            else:
                stName=re.sub('_rcp.._r1i1p1','',gcm)
            if stName not in gcm_list:
                gcm_list.append(stName)
    for i, stName in enumerate(gcm_list):
        if i != (len(gcm_list)-1):
            w.write('               "'+stName+'",\n')
        else:
            w.write('               "'+stName+'"\n')
    w.write('           ]\n')
    w.write('       },\n')
    w.write('       "serviceIdentification" : {\n')
    w.write('           "sos" : "'+sosRoot+'{shapefile}/{gcm}_{scenario}-'+derivative.replace('.nc','')+'-{threshold}"\n')
    w.write('       }\n')
    w.write('   }\n')
    w.write(']\n')
    w.close()
    w=open(os.path.join(wd,deriv+'_scenarios.json'),'w')
    w.write('[\n')
    init=1
    for j, scenario in enumerate(scenarios.keys()):
        if init == 1:
            w.write('   {\n')
            init+=1
        w.write('       "identifier" : "'+deriv+'_'+scenario+'",\n')
        w.write('       "descriptiveKeywords" : {\n')
        w.write('           "scenarios" : [\n')
        w.write('               "'+scenarios[scenario]+'"\n')
        w.write('           ],\n')
        w.write('		    "gcm" : [\n')
        gcm_list=[]
        for i, gcm in enumerate(gcms):
            if not gcm.startswith('.') and scenario in gcm:
                if 'ensemble' in gcm:
                    stName=re.sub('_rcp..','',gcm)
                else:
                    stName=re.sub('_rcp.._r1i1p1','',gcm)
                if stName not in gcm_list:
                    gcm_list.append(stName)
        for i, stName in enumerate(gcm_list):
            if i != (len(gcm_list)-1):
                w.write('               "'+stName+'",\n')
            else:
                w.write('               "'+stName+'"\n')
        w.write('           ]\n')
        w.write('       },\n')
        w.write('       "serviceIdentification" : {\n')
        w.write('           "wms" : "'+wmsRoot+derivative.replace('.nc','_cmip5_der_periods_'+scenario+'.ncml?service=WMS&version=1.1.1&request=GetCapabilities')+'"\n')
        w.write('       }\n')
        if j != (len(scenarios.keys())-1):
            w.write('   },{\n')
        else:
            w.write('   }\n')
    w.write(']\n')
    w.close()
            