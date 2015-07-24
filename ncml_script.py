mport os
wd='/mnt/thredds/bcca/cmip5/data/derivatives/ncml/'
folders=['cmip5_der','cmip5_der_periods','cmip5_hist_der','cmip5_hist_der_periods']
derivatives=["cooling_degree_day.nc","days_tmax_abv.nc","growing_degree_day.nc",
            "heating_degree_day.nc","longest_run_tmax_abv.nc","days_prcp_abv.nc",
            "days_tmin_blw.nc","growing_season_lngth.nc","longest_run_prcp_blw.nc"]
for folder in folders:
    print folder
    gcms=os.listdir(os.path.join(wd,'../',folder))
    print gcms
    for derivative in derivatives:
        if '.nc' in derivative:
            deriv=derivative.replace('.nc','')
            w=open(os.path.join(wd,deriv+'_'+folder+'.ncml'),'w')
            w.write('<netcdf xmlns="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2">\n')
            w.write('   <aggregation type="union">\n')
            for gcm in gcms:
                print gcm
                if not gcm.startswith('.'):
                    file_path=os.path.join('../'+folder,gcm,derivative)
                    w.write('       <netcdf location="'+file_path+'">\n')
                    varName=gcm+'-'+deriv
                    w.write('           <variable orgName="'+deriv+'" name="'+varName+'"/>\n')
                    w.write('       </netcdf>\n')
            w.write('   </aggregation>\n')
            w.write('</netcdf>\n')
            w.close()

scenarios=['rcp26','rcp45','rcp60','rcp85']

folder='cmip5_der_periods'
for scenario in scenarios:
    gcms=os.listdir(os.path.join(wd,'../',folder))
    for derivative in derivatives:
        if '.nc' in derivative:
            deriv=derivative.replace('.nc','')
            w=open(os.path.join(wd,deriv+'_'+folder+'_'+scenario+'.ncml'),'w')
            w.write('<netcdf xmlns="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2">\n')
            w.write('   <aggregation type="union">\n')
            for gcm in gcms:
                print gcm
                if not gcm.startswith('.') and scenario in gcm:
                    file_path=os.path.join('../'+folder,gcm,derivative)
                    w.write('       <netcdf location="'+file_path+'">\n')
                    varName=gcm+'-'+deriv
                    w.write('           <variable orgName="'+deriv+'" name="'+varName+'"/>\n')
                    w.write('       </netcdf>\n')
            w.write('   </aggregation>\n')
            w.write('</netcdf>\n')
            w.close()

