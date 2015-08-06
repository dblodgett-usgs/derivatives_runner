library(derivativesRunner)

# Set script constants
storage_root<-'/Volumes/Scratch/thredds/bcca/bcca/cmip5' # Where all the data will end up at rest.
out_path<-'/Volumes/Striped/' # Where data will get written to durring processing.
bbox_in<-c(-67.06,52.81,-124.6,25.18) # bbox of the data.
cpus<-25

derivatives_runner(storage_root, out_path, bbox_in, cpus)
