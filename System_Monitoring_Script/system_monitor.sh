#!/bin/bash

# Simple System Health Monitoring Script 

echo "===================================="
echo "    SYSTEM HEALTH CHECK REPORT"
echo "===================================="
echo "Date: $(date)"
echo ""

# 1. Check system information
echo "--- BASIC SYSTEM INFO ---"
echo "Computer name: $(hostname)"
echo "Operating system: $(uname -s)"
echo -e "OS Version:$(cat /etc/*-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')"
echo -e "Kernel:$(uname -r)"
echo -e "Architecture:$(uname -m)"
echo "How long system is running: $(uptime -p)"
echo ""

# 2. Check CPU usage
echo "--- CPU USAGE ---"
echo "Current CPU usage:"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage: " $2}'
echo ""

# 3. Check memory (RAM) usage  
echo "--- MEMORY USAGE ---"
echo "RAM Information:"
free -h | grep "Mem:" | awk '{print "Total RAM: " $2 ", Used: " $3 ", Available: " $7}'
echo ""

# 4. Check disk space
echo "--- DISK SPACE ---"
echo "Hard drive space:"
df -h / | grep "/" | awk '{print "Total: " $2 ", Used: " $3 ", Available: " $4 ", Usage: " $5}'
echo ""

# 5. Check top 3 programs using most CPU
echo "--- TOP 3 PROGRAMS USING CPU ---"
ps aux --sort=-%cpu | head -4 | tail -3 | awk '{print $11 " - " $3 "% CPU"}'
echo ""


# Check SSH service
if systemctl is-active --quiet ssh; then
    echo "SSH service: Running ✓"
else
    echo "SSH service: Not running ✗"
fi

# Check network service
if systemctl is-active --quiet networking; then
    echo "Network service: Running ✓"
else
    echo "Network service: Not running ✗"
fi
echo ""


# 6. Simple health summary
echo "--- HEALTH SUMMARY ---"

# Check if CPU usage is high (over 80%)
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//')
if (( $(echo "$cpu_usage > 80" | bc -l) )); then
    echo "⚠️  WARNING: High CPU usage detected!"
else
    echo "✅ CPU usage is normal"
fi

# Check if disk usage is high (over 80%)
disk_usage=$(df / | grep "/" | awk '{print $5}' | sed 's/%//')
if [ "$disk_usage" -gt 80 ]; then
    echo "⚠️  WARNING: Disk space is running low!"
else
    echo "✅ Disk space is sufficient"
fi

# Check if RAM usage is high (over 80%)
ram_usage=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
if [ "$ram_usage" -gt 80 ]; then
    echo "⚠️  WARNING: High memory usage detected!"
else
    echo "✅ Memory usage is normal"
fi

echo ""
echo "===================================="
echo "     HEALTH CHECK COMPLETED"
echo "===================================="

