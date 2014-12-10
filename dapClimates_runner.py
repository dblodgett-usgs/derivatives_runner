import os
import subprocess
import time
import shlex
import csv
processes = []
max_processes = 5
pause_time=10
file_processing = 1
with open('unique_data.csv', 'rb') as csvfile:
  dataIdReader = csv.reader(csvfile, delimiter=',')
  for row in dataIdReader:
    command=shlex.split('Rscript dapClimates_script.R '+row[1])
    print str(file_processing)+ ' of ' + str(134)
    file_processing+=1
    processes.append(subprocess.Popen(command))
    if len(processes) < max_processes:
        time.sleep(pause_time)
    while len(processes) >= max_processes:
        time.sleep(pause_time*2)
        processes = [proc for proc in processes if proc.poll() is None]

while len(processes) > 0:
    time.sleep(pause_time)
    processes = [proc for proc in processes if proc.poll() is None]
