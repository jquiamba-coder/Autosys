#!/bin/python3
import psutil, datetime
import platform
import os

save_path = '/var/autosys/con/int/working/'
file_name = "sysutil_info.dat"

#Get machine-info
machine_info = platform.uname()
machine_info = str(machine_info)
CompleteFilePath = os.path.join(save_path, file_name)
with open(CompleteFilePath, "w") as output_file:
    output_file.write("Machine Info: " + machine_info)
    output_file.write("\n\n")
    #Check boot time (seconds)
    output_file.write("Boot Time (in seconds): " + str(psutil.boot_time()))
    output_file.write("\n\n")
    #Get number of cpu
    output_file.write("Number of CPU Cores in System: " + str(psutil.cpu_count()))
    output_file.write("\n")
    output_file.write("CPU Utilization %: " + str(psutil.cpu_percent(1)))
    output_file.write("\n")
    output_file.write("CPU Stats: " + str(psutil.cpu_stats()))
    output_file.write("\n\n")
    output_file.write("CPU Frequency (in MHz): " + str(psutil.cpu_freq()))
    output_file.write("\n\n")
    output_file.write("CPU Load Average (in last 1, 5 and 15 minutes): " + str(psutil.getloadavg()))
    output_file.write("\n\n")
    #memory info
    output_file.write("Virtual Memory: " + str(psutil.virtual_memory()))
    output_file.write("\n\n")
    #User count
    output_file.write("Users: " + str(psutil.users()))
    output_file.write("\n\n")
    #Disk partitions and usage info
    output_file.write("Disk Usage: " + str(psutil.disk_usage('/')))
    output_file.write("\n\n")
    output_file.write("Disk Partions: " + str(psutil.disk_partitions()))
