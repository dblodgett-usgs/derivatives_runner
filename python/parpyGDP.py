import os
import sys
import subprocess
import time
import shlex
executable=sys.argv[1]
script=sys.argv[2]
data_path=sys.argv[3]
processes = []
max_processes = 10
pause_time=2
file_processing = 1
while file_processing<10:
    command=shlex.split(executable, script, data_path)
    print str(file_processing)+ ' of ' + str(5)
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
