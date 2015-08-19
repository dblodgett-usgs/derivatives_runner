library(derivativesRunner)

# Set script constants
storage_root<-'/Volumes/Scratch/thredds/bcca/bcca/cmip5' # Where all the raw data is.
out_root<-'/Volumes/Striped/final_derivatives' # Where data will get written to durring processing.
package_files<-'/Volumes/Scratch/dblodgett_workspace/derivatives_runner' # There's probably a better way.
bbox_in<-c(-67.06,52.81,-124.6,25.18) # bbox of the data.
cpus<-25

# Run derivatives
derivatives_runner_fun(storage_root, out_root, bbox_in, cpus)

# User this python
py_virt_env<-'/Volumes/Scratch/dblodgett_workspace/pyGDP/venv/bin/python'

ncml_path<-file.path(out_root,'derivatives','ncml')
ncml_script<-file.path(package_files,'python','ncml_script.py')
dir.create(ncml_path, recursive = TRUE)
# Create ncml for output data.
system(paste(py_virt_env, ncml_script, ncml_path))

pyGDP_runner<-file.path(package_files,'python','parpyGDP.py')
pyGDP_script<-file.path(package_files,'python','pyGDP_runner.py')

gdp_output_root<-file.path(out_root,'pyGDP_output/run')
dir.create(gdp_output_root, recursive = TRUE)

# Kick off pyGDP
system(paste(py_virt_env, pyGDP_runner, py_virt_env, pyGDP_script, gdp_output_root))

# convert gdp output to netcdf.dsg
write_dsg(file.path(out_root,'pyGDP_output/run'),cpus=cpus)

# Move NetCDF files around.
dirs<-list.dirs(file.path(out_root,'pyGDP_output/run'),recursive = FALSE)
for(dir in dirs){
  files<-list.files(path = file.path(dir,'nc'), pattern = '*.nc',full.names = TRUE)
  for(file in files){
    print(file.path(dir,basename(file)))
  }
}