library(derivativesRunner)

# Set script constants
storage_root<-'/Volumes/Scratch/thredds/bcca/bcca/cmip5' # Where all the raw data is.
out_root<-'/Volumes/Striped/final_derivatives' # Where data will get written to durring processing.
bbox_in<-c(-67.06,52.81,-124.6,25.18) # bbox of the data.
cpus<-25

# Run derivatives
derivatives_runner_fun(storage_root, out_root, bbox_in, cpus)

# User this python
py_virt_env<-'/Volumes/Scratch/dblodgett_workspace/pyGDP/venv/bin/python'

ncml_path<-file.path(out_root,'ncml')
ncml_script<-file.path(find.package(package=derivativesRunner),'python','ncml_script.py')
dir.create(ncml_path, recursive = TRUE)
# Create ncml for output data.
system(paste(py_virt_env, ncml_script, ncml_path))

pyGDP_runner<-file.path(find.package(package=derivativesRunner),'python','parpyGDP.py')
pyGDP_script<-file.path(find.package(package=derivativesRunner),'python','pyGDP_runner.py')

gdp_output_root<-file.path(out_root,'pyGDP_output/run')
dir.create(gdp_output_root, recursive = TRUE)

# Kick off pyGDP
system(paste(py_vert_env, pyGDP_runner, py_vert_env, pyGDP_script, gdp_output_root))