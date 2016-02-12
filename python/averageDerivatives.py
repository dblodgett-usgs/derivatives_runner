#!/usr/bin/python

'''*************************************************************************************************
Program: averageDerivatives.py

Synopsis:
A simple python script that iterates through the various GCM's derivative data and calculates
decadal averages

Usage: ./averageDerivatives.py [args]

Arguments:
filedir 		-	The location of the source files
outfolder		-	The destination folder for output

*************************************************************************************************'''

import subprocess, os, glob
import calendar as cal
from datetime import date
import argparse

if __name__ == '__main__':
    
	parser = argparse.ArgumentParser()
	parser.add_argument('filedir', type=str)
	parser.add_argument('outfolder', type=str)
	args = parser.parse_args()
	
	#Define the source folder for the input files
	filedir = args.filedir
	
	#Define the destination folder for the output
	outfolder = args.outfolder
	
	
	#Find all "historical" data in the source location
	models = ['inmcm4','bcc-csm1-1','NorESM1-M','MRI-CGCM3','MPI-ESM-MR','MPI-ESM-LR',
	'MIROC5','MIROC-ESM','MIROC-ESM-CHEM','IPSL-CM5A-MR','IPSL-CM5A-LR','GFDL-ESM2M',
	'GFDL-ESM2G','GFDL-CM3','CanESM2','CSIRO-Mk3-6-0','CNRM-CM5','CESM1-BGC','CCSM4',
	'BNU-ESM','ACCESS1-0']
	for i in range(len(models)):
		files = glob.glob(filedir+"/*"+models[i]+"*historical*.nc")
		for j in range(len(files)):
			var = files[j].split("r1i1p1_")[1].split(".")[0]
			ndx1 = 0
			ndx2 = 9
			for k in range(5):
				cmd = "ncwa -h -a time -d time,"+str(ndx1)+","+str(ndx2)+",1 -v "+var+" "+files[j]+" tmp"+str(k)+".nc"
				process = subprocess.call(cmd,shell=True)
				cmd = "ncecat -h -O -u time "+"tmp"+str(k)+".nc "+"tmp"+str(k)+".nc"
				process = subprocess.call(cmd,shell=True)
				cmd = "ncks -h -O --mk_rec_dmn time "+"tmp"+str(k)+".nc "+"tmp"+str(k)+".nc"
				process = subprocess.call(cmd,shell=True)
				ndx1 = ndx2+1
				ndx2 = ndx1+9
			tmpfiles = glob.glob("./tmp*.nc")
			tmpfiles.sort()
			cmd = "ncrcat -h "+" ".join(tmpfiles)+" "+models[i]+"_historical_"+var+"_decadal.nc"
			process = subprocess.call(cmd,shell=True)
			cmd = "rm tmp*.nc"
			process = subprocess.call(cmd,shell=True)
			cmd = "mv *.nc "+outfolder+"/"
			process = subprocess.call(cmd,shell=True)	

	
	#Find all "rcp45" data in the source location
	models = ['inmcm4','bcc-csm1-1','NorESM1-M','MRI-CGCM3','MPI-ESM-MR','MPI-ESM-LR','MIROC5',
	'MIROC-ESM','MIROC-ESM-CHEM','IPSL-CM5A-MR','IPSL-CM5A-LR','GFDL-ESM2M','GFDL-ESM2G',
	'CanESM2','CSIRO-Mk3-6-0','CNRM-CM5','CESM1-BGC','CCSM4','BNU-ESM','ACCESS1-0']	
	for i in range(len(models)):
		files = glob.glob(filedir+"/*"+models[i]+"*rcp45*.nc")
		for j in range(len(files)):
			var = files[j].split("r1i1p1_")[1].split(".")[0]
			ndx1 = 4
			ndx2 = 13
			for k in range(9):
				cmd = "ncwa -h -a time -d time,"+str(ndx1)+","+str(ndx2)+",1 -v "+var+" "+files[j]+" tmp"+str(k)+".nc"
				process = subprocess.call(cmd,shell=True)
				cmd = "ncecat -h -O -u time "+"tmp"+str(k)+".nc "+"tmp"+str(k)+".nc"
				process = subprocess.call(cmd,shell=True)
				cmd = "ncks -h -O --mk_rec_dmn time "+"tmp"+str(k)+".nc "+"tmp"+str(k)+".nc"
				process = subprocess.call(cmd,shell=True)
				ndx1 = ndx2+1
				ndx2 = ndx1+9
			tmpfiles = glob.glob("./tmp*.nc")
			tmpfiles.sort()
			cmd = "ncrcat -h "+" ".join(tmpfiles)+" "+models[i]+"_rcp45_"+var+"_decadal.nc"
			process = subprocess.call(cmd,shell=True)
			cmd = "rm tmp*.nc"
			process = subprocess.call(cmd,shell=True)
			cmd = "mv *.nc "+outfolder+"/"
			process = subprocess.call(cmd,shell=True)
			

	

	#Find all "rcp85" data in the source location
	models = ['inmcm4','bcc-csm1-1','NorESM1-M','MRI-CGCM3','MPI-ESM-MR','MPI-ESM-LR','MIROC5',
	'MIROC-ESM','MIROC-ESM-CHEM','IPSL-CM5A-MR','IPSL-CM5A-LR','GFDL-ESM2M','GFDL-ESM2G',
	'GFDL-CM3','CanESM2','CSIRO-Mk3-6-0','CNRM-CM5','CESM1-BGC','CCSM4','BNU-ESM','ACCESS1-0']
	for i in range(len(models)):
		files = glob.glob(filedir+"/*"+models[i]+"*rcp85*.nc")
		for j in range(len(files)):
			var = files[j].split("r1i1p1_")[1].split(".")[0]
			ndx1 = 4
			ndx2 = 13
			for k in range(9):
				cmd = "ncwa -h -a time -d time,"+str(ndx1)+","+str(ndx2)+",1 -v "+var+" "+files[j]+" tmp"+str(k)+".nc"
				process = subprocess.call(cmd,shell=True)
				cmd = "ncecat -h -O -u time "+"tmp"+str(k)+".nc "+"tmp"+str(k)+".nc"
				process = subprocess.call(cmd,shell=True)
				cmd = "ncks -h -O --mk_rec_dmn time "+"tmp"+str(k)+".nc "+"tmp"+str(k)+".nc"
				process = subprocess.call(cmd,shell=True)
				ndx1 = ndx2+1
				ndx2 = ndx1+9
			tmpfiles = glob.glob("./tmp*.nc")
			tmpfiles.sort()
			cmd = "ncrcat -h "+" ".join(tmpfiles)+" "+models[i]+"_rcp85_"+var+"_decadal.nc"
			process = subprocess.call(cmd,shell=True)
			cmd = "rm tmp*.nc"
			process = subprocess.call(cmd,shell=True)
			cmd = "mv *.nc "+outfolder+"/"
			process = subprocess.call(cmd,shell=True)