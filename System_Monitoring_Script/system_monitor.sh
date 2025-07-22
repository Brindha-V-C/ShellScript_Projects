#!/bin/bash


#About:  This is a script to monitor the system performance and to analyze the health of software and hardware


# Colors for output
WHITE="\033[1;37m"
CYAN="\033[1;36m"
RESET="\033[0m"

log_file="/var/log/system_health_report.log"

echo -e "${WHITE}========== System Health Check Report ==========${RESET}"
echo "Report generated at: $(date)" | tee -a $log_file

## System Info
echo -e "${CYAN}Hostname:${RESET}        $(hostname -f)"
echo -e "${CYAN}Uptime:${RESET}          $(uptime -p)"
echo -e "${CYAN}OS Version:${RESET}      $(cat /etc/*-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')"
echo -e "${CYAN}Kernel:${RESET}          $(uname -r)"
echo -e "${CYAN}Architecture:${RESET}    $(uname -m)"

## CPU Stats
echo -e "${WHITE}\n--- CPU Usage ---${RESET}"
mpstat | awk '$12 ~ /[0-9.]+/ { print "CPU Idle: " $12"%"; print "CPU Usage: "100-$12"%" }'
echo -e "Load Average: $(uptime | awk -F'load average:' '{ print $2 }' | xargs)"

## Memory Stats
echo -e "${WHITE}\n--- Memory Usage ---${RESET}"
free -h | awk '/^Mem:/{print "Total RAM: "$2"\nUsed RAM : "$3"\nFree RAM : "$4 }'
free | awk '/^Mem:/ {printf "Memory Usage: %.2f%%\n", $3/$2*100}'
free | awk '/^Swap:/ {printf "Swap Usage: %.2f%%\n", $3/$2*100}'

## Disk Usage
echo -e "${WHITE}\n--- Disk Usage ---${RESET}"
df -h | grep '^/dev/' | awk '{print $1": "$5" used ("$4" available) mounted on "$6}'

## Top Processes
echo -e "${WHITE}\n--- Top 5 CPU-consuming Processes ---${RESET}"
ps -eo pid,cmd,%cpu --sort=-%cpu | head -6

echo -e "${WHITE}\n--- Top 5 Memory-consuming Processes ---${RESET}"
ps -eo pid,cmd,%mem --sort=-%mem | head -6

## Systemd Failed Services
echo -e "${WHITE}\n--- Failed System Services ---${RESET}"
systemctl --failed | awk 'NR>1{print $1,$2,$3,$4}'

## Hardware Health
echo -e "${WHITE}\n--- Basic Hardware Health ---${RESET}"
echo -e "Product: $(cat /sys/class/dmi/id/product_name 2>/dev/null)"
echo -e "Serial:  $(cat /sys/class/dmi/id/product_serial 2>/dev/null)"
which sensors >/dev/null && sensors | grep 'Core' || echo "sensors not installed/skipped (CPU temp)"
if [ -b /dev/sda ]; then
    which smartctl >/dev/null && sudo smartctl -H /dev/sda | grep overall || echo "smartctl not installed/skipped"
fi

## Network Information
echo -e "${WHITE}\n--- Network ---${RESET}"
echo -e "IP(s): $(hostname -I)"
netstat -i | grep -vE '^Kernel|Iface|lo'

## System Logs
echo -e "${WHITE}\n--- Recent System Errors (syslog/journal) ---${RESET}"
journalctl -p 3 -xb | tail -10
dmesg | tail -10

## Log and Alert Option
echo "Report saved to $log_file"

