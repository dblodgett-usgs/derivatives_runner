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
products=['monthly','annual', 'seasonal']
temps=['tasmax','tasmin','pr']
commands=[]
for i in range(len(files)):
	for j in range(len(products)):
		for k in range(len(temps)):
			if os.path.isfile("/Volumes/scratch2/out/"+files[i].replace('.nc','')+"_"+temps[k]+"_"+products[j]+"_merged.nc")==False:
				commands.append(shlex.split("python catBCCA.py /Volumes/temp_striped/unmerged_hist "+files[i].replace('.nc','')+"_"+temps[k]+" "+products[j]+" /Volumes/scratch2/out"))
file_processing=0
for command in commands:
	print command	
while file_processing<len(commands):
	print str(file_processing)
	print commands[file_processing]
	processes.append(subprocess.Popen(commands[file_processing]))
	file_processing+=1
	if len(processes) < max_processes:
		time.sleep(pause_time)
	while len(processes) >= max_processes:
		time.sleep(pause_time*2)
		processes = [proc for proc in processes if proc.poll() is None]

while len(processes) > 0:
	time.sleep(pause_time)
	processes = [proc for proc in processes if proc.poll() is None]