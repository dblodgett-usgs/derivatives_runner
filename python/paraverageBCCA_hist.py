#!/Volumes/Scratch/dblodgett_workspace/pyGDP/venv/bin/python
import os
import subprocess
import time
import shlex
processes = []
max_processes = 4
pause_time=2
file_processing = 1
files=("ACCESS1-0_historical_r1i1p1.nc",
"BNU-ESM_historical_r1i1p1.nc",
"CCSM4_historical_r1i1p1.nc",
# "CCSM4_historical_r2i1p1.nc",
"CESM1-BGC_historical_r1i1p1.nc",
"CNRM-CM5_historical_r1i1p1.nc",
# "CSIRO-Mk3-6-0_historical_r10i1p1.nc",
"CSIRO-Mk3-6-0_historical_r1i1p1.nc",
# "CSIRO-Mk3-6-0_historical_r2i1p1.nc",
# "CSIRO-Mk3-6-0_historical_r3i1p1.nc",
# "CSIRO-Mk3-6-0_historical_r4i1p1.nc",
# "CSIRO-Mk3-6-0_historical_r5i1p1.nc",
# "CSIRO-Mk3-6-0_historical_r6i1p1.nc",
# "CSIRO-Mk3-6-0_historical_r7i1p1.nc",
# "CSIRO-Mk3-6-0_historical_r8i1p1.nc",
# "CSIRO-Mk3-6-0_historical_r9i1p1.nc",
"CanESM2_historical_r1i1p1.nc",
# "CanESM2_historical_r2i1p1.nc",
# "CanESM2_historical_r3i1p1.nc",
# "CanESM2_historical_r4i1p1.nc",
# "CanESM2_historical_r5i1p1.nc",
"GFDL-CM3_historical_r1i1p1.nc",
"GFDL-ESM2G_historical_r1i1p1.nc",
"GFDL-ESM2M_historical_r1i1p1.nc",
"IPSL-CM5A-LR_historical_r1i1p1.nc",
# "IPSL-CM5A-LR_historical_r2i1p1.nc",
# "IPSL-CM5A-LR_historical_r3i1p1.nc",
# "IPSL-CM5A-LR_historical_r4i1p1.nc",
"IPSL-CM5A-MR_historical_r1i1p1.nc",
"MIROC-ESM-CHEM_historical_r1i1p1.nc",
"MIROC-ESM_historical_r1i1p1.nc",
"MIROC5_historical_r1i1p1.nc",
# "MIROC5_historical_r2i1p1.nc",
# "MIROC5_historical_r3i1p1.nc",
"MPI-ESM-LR_historical_r1i1p1.nc",
# "MPI-ESM-LR_historical_r2i1p1.nc",
# "MPI-ESM-LR_historical_r3i1p1.nc",
"MPI-ESM-MR_historical_r1i1p1.nc",
# "MPI-ESM-MR_historical_r2i1p1.nc",
# "MPI-ESM-MR_historical_r3i1p1.nc",
"MRI-CGCM3_historical_r1i1p1.nc",
"NorESM1-M_historical_r1i1p1.nc",
"bcc-csm1-1_historical_r1i1p1.nc",
"inmcm4_historical_r1i1p1.nc")
tasmax=True
pr_run=True
while file_processing<=len(files):
    print str(file_processing)
    if pr_run:
        command=shlex.split("python averageBCCA.py /Volumes/Scratch/thredds/bcca/bcca/cmip5/data/historical/"+files[file_processing-1]+" BCCA_0-125deg_pr_day_"+files[file_processing-1].replace('.nc','')+" hist "+files[file_processing-1].replace('.nc','')+"_pr /Volumes/temp_striped/unmerged_hist")
        file_processing+=1
    else:
        if tasmax:
            command=shlex.split("python averageBCCA.py /Volumes/temp_striped/data/"+files[file_processing-1]+" BCCA_0-125deg_tasmax_day_"+files[file_processing-1].replace('.nc','')+" hist "+files[file_processing-1].replace('.nc','')+"_tasmax /Volumes/temp_striped/unmerged_hist")
            tasmax=False
        else:
            command=shlex.split("python averageBCCA.py /Volumes/temp_striped/data/"+files[file_processing-1]+" BCCA_0-125deg_tasmin_day_"+files[file_processing-1].replace('.nc','')+" hist "+files[file_processing-1].replace('.nc','')+"_tasmin /Volumes/temp_striped/unmerged_hist")
            file_processing+=1
            tasmax=True
    print(command)
    processes.append(subprocess.Popen(command))
    if len(processes) < max_processes:
		time.sleep(pause_time)
    while len(processes) >= max_processes:
        time.sleep(pause_time*2)
        processes = [proc for proc in processes if proc.poll() is None]
while len(processes) > 0:
    time.sleep(pause_time)
    processes = [proc for proc in processes if proc.poll() is None]
