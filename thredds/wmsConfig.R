library(whisker)

gcms = c("ensemble", "ACCESS1-0","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC","CSIRO-Mk3-6-0","GFDL-CM3",
         "GFDL-ESM2G","GFDL-ESM2M","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC-ESM","MIROC-ESM-CHEM",
         "MIROC5","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M")

varNames = c("cooling_degree_day","days_tmax_abv","growing_degree_day",
             "heating_degree_day","longest_run_tmax_abv","days_prcp_abv",
             "days_tmin_blw","growing_season_lngth","longest_run_prcp_blw")

scenarios = c("rcp26", "rcp45", "rcp60", "rcp85", "historical")

mins = c(0, 0, 0,
		 0, 0, 0,
		 0, 0, 0)
maxes = c(4000, 250, 5500,
		  7500, 125, 50,
		  250, 366, 200)
deltaMins = c(0, 0, 0,
			  -2200, 0, -1,
			  -100, -10, -25)
deltaMaxes = c(1200, 100, 1300,
			   0, 150, 5,
			   0, 100, 25)

servicePath <- "cmip5_bcca/derivatives/*der_periods*"
diffServicePath <- "cmip5_bcca/derivatives/*der_diff_rcp*"

makeConfig <- function(path, minVector, maxVector) {
	df <- data.frame(character(0), numeric(0), numeric(0))
	for (i in 1:length(varNames)) {
		for (j in 1:length(gcms)) {
		  for (k in 1:length(scenarios)){
		    if (grepl('ensemble', gcms[j])) {
			    name = paste0(gcms[j],"_", scenarios[k], "-", varNames[i])
		    } else {
		      name = paste0(gcms[j],"_",scenarios[k], "_r1i1p1-", varNames[i])
		    }
		  df <- rbind(df, data.frame(name, minVector[i], maxVector[i]))
		  }
		}
	}
	names(df) <- c("name", "min", "max")
	vars <- lapply(rowSplit(df), as.list)
	vars <- unname(vars)
	return(list(servicePath=path, vars=vars))
}

data <- list(services=list(makeConfig(servicePath, mins, maxes),
                           makeConfig(diffServicePath, deltaMins, deltaMaxes)))

# any other variables may be added to the template
template <- readLines("./wmsConfig-template.xml")
cat(whisker.render(template, data), file="wmsConfig.xml", append=FALSE)
