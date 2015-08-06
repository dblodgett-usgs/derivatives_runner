path<-list(
  historical_data_path='/data/historical/', # Where the raw historical data originates
  future_data_path='/data/future/', # Where the raw future data originates
  out_path='/Volumes/Striped/', 
  future_path='/derivatives/cmip5_der/', # Where the future derivatives get moved to.
  hist_path='/derivatives/cmip5_hist_der/', # Where the historical derivatives get moved to.
  historical_periods_path='/derivatives/cmip5_hist_der_periods/', # Where the historical periods go 
  future_periods_path='/derivatives/cmip5_der_periods/', # Where the future periods go.
  difference_path='/derivatives/cmip5_der_diff/') # Where the difference output gos.

thresholds=list(days_tmax_abv_thresh=c(32.2222,35,37.7778),
                days_tmin_blw_thresh=c(-17.7778,-12.2222,0),
                days_prcp_abv_thresh=c(25.4,50.8,76.2,101.6),
                longest_run_tmax_abv_thresh=c(32.2222,35,37.7778),
                longest_run_prcp_blw_thresh=c(76.2),
                growing_degree_day_thresh=c(15.5556),
                heating_degree_day_thresh=c(18.3333),
                cooling_degree_day_thresh=c(18.3333),
                growing_season_lngth_thresh=c(0))