#!/usr/bin/python

'''*************************************************************************************************
Program: catBCCA.py

Synopsis:
A python script that iterates through a set of BCCA netCDF files adding the time record
and then concatenating all the individual files into one collection 

Usage: ./catBCCA.py [args]

Arguments:
sourceDir		-	The directory containing the source files
fileprefix		-	The prefix of the input (and resulting output) netCDF files
fileprod		-	The type of file to be merged (seasonal, annual, or monthly)
outfolder		-	The destination folder for output

*************************************************************************************************'''

import subprocess, os, glob
import calendar as cal
from datetime import date
import argparse


if __name__ == '__main__':
    
	parser = argparse.ArgumentParser()
	parser.add_argument('sourceDir', type=str)
	parser.add_argument('fileprefix', type=str)
	parser.add_argument('fileprod', type=str)
	parser.add_argument('outfolder', type=str)
	args = parser.parse_args()
	
	#The daily file (e.g., source of daily data) 
	sourceDir = args.sourceDir
	
	#define the input/output netcdf file name prefix
	fileprefix = args.fileprefix
	
	#define the product (e.g., tasmax, tasmin, pr)
	fileprod = args.fileprod
	
	outfolder = args.outfolder


	files = glob.glob(sourceDir+"/"+fileprefix+"*"+fileprod+"*.nc")
	files.sort()

	for file in files:
		#first check if the time record dimension has already been written
		cmd = "ncdump -h "+file+" | grep UNLIMITED"
		rtest = subprocess.Popen(cmd, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, close_fds=True)
		if(len(rtest.stdout.read()) == 0):
			cmd = "ncecat -h -O -u time "+file+" "+file
			FNULL = open(os.devnull, 'w')
			process = subprocess.call(cmd,shell=True,stdout=FNULL,stderr=subprocess.STDOUT)
			cmd = "ncks -h -O --mk_rec_dmn time "+file+" "+file
			FNULL = open(os.devnull, 'w')
			process = subprocess.call(cmd,shell=True)#,stdout=FNULL,stderr=subprocess.STDOUT)
	
	
	cmd = "ncrcat -h "+" ".join(files)+" "+fileprefix+"_"+fileprod+"_merged.nc"
	process = subprocess.call(cmd,shell=True)
	
	cmd1 = "mv "+fileprefix+"* "+outfolder
	subprocess.call(cmd1,shell=True)
