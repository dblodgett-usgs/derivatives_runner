#!/usr/bin/python

'''*************************************************************************************************
Program: catBCCA.py

Usage: Either from command line or during a python (or ipython) session
	command line
	>./catBCCA.py [args]
	or from ipython:
	In [1]: %run catBCCA.py [args]

Synopsis:
A simple python script that iterates through a set of BCCA netCDF files adding the time record
and then concatenating all the individual files into one collection 

sourceDir		-	The directory containing the source files
outfileprefix	-	The prefix of the resulting netCDF file

*************************************************************************************************'''

import subprocess, os, glob
import calendar as cal
from datetime import date
import argparse


if __name__ == '__main__':
    
	parser = argparse.ArgumentParser()
	parser.add_argument('sourceDir', type=str)
	parser.add_argument('outfileprefix', type=str)
	parser.add_argument('outfolder', type=str)
	args = parser.parse_args()
	
	#The daily file (e.g., source of daily data) 
	sourceDir = args.sourceDir
	
	#define the output netcdf file name
	outfileprefix = args.outfileprefix # "BCCA_0.125deg_tasmax_ACCESS1-0_historical_"
	
	outfolder = args.outfolder


	files = glob.glob(sourceDir+"/*.nc")
	files.sort()

	for file in files:
		#first check if the time record dimension has already been written
		cmd = "ncdump -h "+file+" | grep UNLIMITED"
		rtest = subprocess.Popen(cmd, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, close_fds=True)
		if(len(rtest.stdout.read()) == 0):
			cmd = "ncecat -O -u time "+file+" "+file
			FNULL = open(os.devnull, 'w')
			process = subprocess.call(cmd,shell=True,stdout=FNULL,stderr=subprocess.STDOUT)
			cmd = "ncks -O --mk_rec_dmn time "+file+" "+file
			FNULL = open(os.devnull, 'w')
			process = subprocess.call(cmd,shell=True)#,stdout=FNULL,stderr=subprocess.STDOUT)
	
	
	cmd = "ncrcat "+" ".join(files)+" "+outfileprefix+"_merged.nc"
	process = subprocess.call(cmd,shell=True)
	
	cmd1 = "mv "+outfileprefix+"* "+outfolder
	subprocess.call(cmd1,shell=True)
