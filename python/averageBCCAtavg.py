#!/usr/bin/python

'''*************************************************************************************************
Program: averageBCCAtavg.py

Synopsis:
A simple python script that iterates through the various climatological periods and calculates the 
average temperature from CMIP5 BCCA data for a given model and/or emissions scenario (for future 
projections). Average temperature here is based on daily (tmax+tmin)/2.

Usage: ./averageBCCA.py [args]

Arguments:
filename		-	The desired source file
tmaxvarname		-	The max temperature variable to be used (e.g., tasmax)
tminvarname		-	The min temperature variable to be used (e.g., tasmin)
period			-	The period of interest, either historical (hist), or future (rcp)
outfileprefix	-	The prefix of the resulting netCDF file
outfolder		-	The destination folder for output

*************************************************************************************************'''

import subprocess, os
import calendar as cal
from datetime import date
import argparse

if __name__ == '__main__':
    
	parser = argparse.ArgumentParser()
	parser.add_argument('filename', type=str)
	parser.add_argument('tmaxvarname', type=str)
	parser.add_argument('tminvarname', type=str)
	parser.add_argument('period', type=str)
	parser.add_argument('outfileprefix', type=str)
	parser.add_argument('outfolder', type=str)
	args = parser.parse_args()
	
	#The daily file (e.g., source of daily data) 
	filename = args.filename
	
	#Variable name
	tmaxvarname = args.tmaxvarname # "tasmax"
	tminvarname = args.tminvarname # "tasmin"
	
	#Year(s) of interest, used as a 1-d array here for iteration (if needed)
	period = args.period
	if period=='rcp':
		yyyy = range(2006,2101)
		timeorigin = date(2006,1,1)
	elif period=='hist':
		yyyy=range(1950,2006)
		timeorigin = date(1950,1,1)
	elif period=='new_gmo':
		yyyy=range(1950,2011)
		timeorigin = date(1950,1,1)


	#define the output netcdf file name
	outfileprefix = args.outfileprefix
	
	#Define the destination folder for the output
	outfolder = args.outfolder

	varname = "tavg"

	for i in range(len(yyyy)):
		newyyyy = yyyy[i]
		newtimeorigin = date(newyyyy,1,1)
		yndx1 = date(newyyyy,1,1) - timeorigin
		yndx1 = yndx1.days
		yndx2 = date(newyyyy,12,31) - timeorigin
		yndx2 = yndx2.days
		newfilename = outfileprefix+"truncated.nc.tmp"
		#Extract tmax into new tmax.nc
		cmd = "ncks --no_blank -d time,"+str(yndx1)+","+str(yndx2)+" -v "+tmaxvarname+" "+filename+" tmax.nc"
		FNULL = open(os.devnull, 'w')
		process = subprocess.call(cmd,shell=True,stdout=FNULL,stderr=subprocess.STDOUT)
		#Extract tmin into new tmin.nc
		cmd = "ncks --no_blank -d time,"+str(yndx1)+","+str(yndx2)+" -v "+tminvarname+" "+filename+" tmin.nc"
		FNULL = open(os.devnull, 'w')
		process = subprocess.call(cmd,shell=True,stdout=FNULL,stderr=subprocess.STDOUT)
		#Append tmax variable into the tmin.nc file
		cmd = "ncks -A tmax.nc tmin.nc"
		FNULL = open(os.devnull, 'w')
		process = subprocess.call(cmd,shell=True,stdout=FNULL,stderr=subprocess.STDOUT) 
		#Now take the average
		cmd = "ncap2 -s \"tavg=('"+tmaxvarname+"'+'"+tminvarname+"')/2\" tmin.nc tavg.nc"
		FNULL = open(os.devnull, 'w')
		process = subprocess.call(cmd,shell=True)#,stdout=FNULL,stderr=subprocess.STDOUT)
		#Lastly, rename the tavg.nc file to the "newfilename" variable so code below doesn't break
		cmd = "mv tavg.nc "+newfilename
		process = subprocess.call(cmd,shell=True)
		#Some cleanup
		cmd2 = "rm tmax.nc tmin.nc"
		subprocess.call(cmd2,shell=True)
		
		#Creating a special cdf for the seasonal calculations since we need the current and following year
		#to get DJF, where Jan and Feb are from the following year
		sndx1 = date(newyyyy,1,1) - timeorigin
		sndx1 = sndx1.days
		sndx2 = date(newyyyy+1,12,31) - timeorigin
		sndx2 = sndx2.days
		seasfilename = outfileprefix+"truncated.seas.nc.tmp"
		if(newyyyy != yyyy[len(yyyy)-1]):
			#Extract tmax into new tmax.nc
			cmd = "ncks --no_blank -d time,"+str(sndx1)+","+str(sndx2)+" -v "+tmaxvarname+" "+filename+" tmax.nc"
			FNULL = open(os.devnull, 'w')
			process = subprocess.call(cmd,shell=True,stdout=FNULL,stderr=subprocess.STDOUT)
			#Extract tmin into new tmin.nc
			cmd = "ncks --no_blank -d time,"+str(sndx1)+","+str(sndx2)+" -v "+tminvarname+" "+filename+" tmin.nc"
			FNULL = open(os.devnull, 'w')
			process = subprocess.call(cmd,shell=True,stdout=FNULL,stderr=subprocess.STDOUT)
			#Append tmax variable into the tmin.nc file
			cmd = "ncks -A tmax.nc tmin.nc"
			FNULL = open(os.devnull, 'w')
			process = subprocess.call(cmd,shell=True,stdout=FNULL,stderr=subprocess.STDOUT) 
			#Now take the average
			cmd = "ncap2 -s \"tavg=('"+tmaxvarname+"'+'"+tminvarname+"')/2\" tmin.nc tavg.nc"
			FNULL = open(os.devnull, 'w')
			process = subprocess.call(cmd,shell=True,stdout=FNULL,stderr=subprocess.STDOUT)
			#Lastly, rename the tavg.nc file to the "newfilename" variable so code below doesn't break
			cmd = "mv tavg.nc "+seasfilename
			process = subprocess.call(cmd,shell=True)
			#Some cleanup
			cmd2 = "rm tmax.nc tmin.nc"
			subprocess.call(cmd2,shell=True)
		
		#Process all of the seasonal averages for the given variable
		#Define the "season months"
		seasonstr = ["03-05","06-08","09-11","12-02"]
		seasons = [[3,4,5],[6,7,8],[9,10,11],[12,1,2]]
		for j in range(4):
			if(newyyyy == yyyy[len(yyyy)-1]): 
				seasfilename = newfilename
				if(j == 3): continue
			dndx1 = (date(newyyyy,seasons[j][0],1) - newtimeorigin)
			dndx1 = dndx1.days
			if(j != 3):
				ndaysinmonth = cal.monthrange(newyyyy, seasons[j][2])[1]
				dndx2 = (date(newyyyy,seasons[j][2],ndaysinmonth) - newtimeorigin)
				dndx2 = dndx2.days
			if(j == 3):
				ndaysinmonth = cal.monthrange(newyyyy+1, seasons[j][2])[1]
				dndx2 = (date(newyyyy+1,seasons[j][2],ndaysinmonth) - newtimeorigin)
				dndx2 = dndx2.days
			cmd = "ncwa -a time -d time,"+str(dndx1)+","+str(dndx2)+",1 -v "+varname+" "+seasfilename+" "+outfileprefix+str(newyyyy)+seasonstr[j]+"_seasonal.nc"
			FNULL = open(os.devnull, 'w')			
			process = subprocess.call(cmd,shell=True,stdout=FNULL,stderr=subprocess.STDOUT)
		#finished with seasonal processing
		
		
		

		#Process all of the annual averages for the given variable
		dndx1 = (date(newyyyy,1,1) - newtimeorigin)
		dndx1 = dndx1.days
		dndx2 = (date(newyyyy,12,31) - newtimeorigin)
		dndx2 = dndx2.days
		cmd = "ncwa -a time -d time,"+str(dndx1)+","+str(dndx2)+",1 -v "+varname+" "+newfilename+" "+outfileprefix+str(newyyyy)+"_annual.nc"
		FNULL = open(os.devnull, 'w')
		process = subprocess.call(cmd,shell=True,stdout=FNULL,stderr=subprocess.STDOUT)	
		#finished with annual processing




	#Process all of the monthly averages for the given variable
		for j in range(12):
			ndx = j+1
			yearstr = str(newyyyy)
			if(ndx <= 9): monstr = "0"+str(ndx)
			if(ndx > 9): monstr = str(ndx)
			dndx1 = (date(newyyyy,ndx,1) - newtimeorigin)
			dndx1 = dndx1.days
			ndaysinmonth = cal.monthrange(newyyyy, ndx)[1]
			dndx2 = (date(newyyyy,ndx,ndaysinmonth) - newtimeorigin)
			dndx2 = dndx2.days
			cmd = "ncwa -a time -d time,"+str(dndx1)+","+str(dndx2)+",1 -v "+varname+" "+newfilename+" "+outfileprefix+str(newyyyy)+monstr+"_monthly.nc"
			FNULL = open(os.devnull, 'w')
			process = subprocess.call(cmd,shell=True,stdout=FNULL,stderr=subprocess.STDOUT)	
		#finished with monthly processing
		
		cmd2 = "rm "+newfilename+" "+seasfilename
		subprocess.call(cmd2,shell=True)
		
		cmd1 = "mv "+outfileprefix+"* "+outfolder
		subprocess.call(cmd1,shell=True)