# Takes periodized derivatives and a single historical period and generates difference grids.

# Previously run derivatives.
data_path<-'/Users/dblodgett/temp/cmip5_der_periods/'

out_path<-'/Users/dblodgett/temp/cmip5_der_diff/'

# Thresholds used with previously run derivatives.
thresholds=list(days_tmax_abv_thresh=c(32.2222,35,37.7778),
                days_tmin_blw_thresh=c(-17.7778,-12.2222,0),
                days_prcp_abv_thresh=c(25.4,50.8,76.2,101.6),
                longest_run_tmax_abv_thresh=c(32.2222,35,37.7778),
                longest_run_prcp_blw_thresh=c(76.2),
                growing_degree_day_thresh=c(15.5556),
                heating_degree_day_thresh=c(18.3333),
                cooling_degree_day_thresh=c(18.3333),
                growing_season_lngth_thresh=c(0))

# Units from previously run derivatives.
p_units<-'mm/d'
t_units<-'C'

# Periods that will be used. These should include n+1 values where n is the number 
# of actual time steps desired. The last vaue should be the end of the final time step.
periods<-c(2011,2040,2070,2099)