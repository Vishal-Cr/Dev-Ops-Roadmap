#!/bin/bash

# My Script to check Server Scripts
echo "================SERVER STATS================"
echo ""
# Total CPU Usage
echo "Total CPU Usage"
mpstat 1 1 | awk '/all/ {print "USER: "$3"% System: "$5"% Idle: "$12"%"}'
echo ""
# Total Memory Usage
echo "Total Memory Usage"

free -m | awk '/Mem/ {
    total=$2;
    used=$3;
    free=$4;
    used_percent=(used/total)*100;
    free_percent=(free/total)*100;
    printf "Total: %dMB Used: %dMB (%.2f%%) Free: %dMB (%.2f%%)\n", total, used, used_percent, free, free_percent
}'
echo ""
# Total Disk Usage(Free vs Used Including Percentage)
echo "Total Disk Usage"
df -h --total| awk '/total/ {
    total=$2;
    used=$3;
    free=$4;
    used_percent=$5;
    printf "Total: %s Used: %s Free: %s Used Percentage: %s\n", total, used, free, used_percent
}'
echo ""
# Top 5 processed by CPU usage
echo "Top 5 processed by CPU usage"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
echo ""
# Top 5 processed by Memory usage
echo "Top 5 processed by Memory usage"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
echo ""
# OS Version
echo "OS Version"
cat /etc/os-release | awk '/PRETTY_NAME/ {print $0}'
echo ""
#Load Average
echo "Load Average"
uptime | awk '{print "Load Average: "$9" "$10" "$11}'
echo ""
#Logged in Users
echo "Logged in Users"
who
echo ""
#Faild Login Attempts
echo "Failed Login Attempts"
if [ -f /var/log/auth.log ]; then
sudo grep "Failed Password" /var/log/auth.log | awk '{print "User: "$9" From: "$11}'
else
echo "auth.log not found"
fi
echo ""
#Network Information
echo "Network Information"
ifconfig | awk '/inet/ {print "IP Address: "$2" Interface: "$1}'
echo ""
#Last reboot time
echo "Last reboot time"
who -b 
echo ""
echo "================END SERVER STATS================"