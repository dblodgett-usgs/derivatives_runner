OPeNDAP_URI<-'http://cida.usgs.gov/thredds/dodsC/cmip5_bcca/future'
OPeNDAP_URI<-'http://localhost:8080/thredds/dodsC/striped/bcca/bcca/cmip5_out/ncmls/unions/BCCA_0.125deg.rcp.ncml'
ncdf4_handle <- nc_open(OPeNDAP_URI)
tmax_var<-"BCCA_0-125deg_tasmax_day_CSIRO-Mk3-6-0_rcp85_r10i1p1"
ncvar_get(ncdf4_handle, tmax_var, c(1,1,1),c(462,222,1))
ncvar_get(ncdf4_handle, tmax_var, c(1,1,2),c(462,222,1))
