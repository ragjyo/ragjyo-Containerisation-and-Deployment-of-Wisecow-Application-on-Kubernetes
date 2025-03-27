#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90
LOG_FILE="/var/log/system_health.log"

# Check CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "[ALERT] High CPU Usage: ${CPU_USAGE}%" | tee -a $LOG_FILE
fi

# Check Memory Usage
MEM_USAGE=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
    echo "[ALERT] High Memory Usage: ${MEM_USAGE}%" | tee -a $LOG_FILE
fi

# Check Disk Space
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if (( DISK_USAGE > DISK_THRESHOLD )); then
    echo "[ALERT] Low Disk Space: ${DISK_USAGE}% used" | tee -a $LOG_FILE
fi

# Check Running Processes
TOP_PROCESSES=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -6)
echo "[INFO] Top Processes:\n$TOP_PROCESSES" | tee -a $LOG_FILE

# Cronjob suggestion for automation
# Add this line to your crontab for periodic checks:
# */10 * * * * /path/to/this_script.sh
