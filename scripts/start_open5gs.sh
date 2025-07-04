#!/bin/bash

# This script starts all Open5GS services.
# Run this script with sudo: sudo ./start_open5gs.sh

echo "Starting Open5GS services..."

# List of Open5GS services to start
SERVICES=(
    open5gs-nrfd.service
    open5gs-udrd.service
    open5gs-udmd.service
    open5gs-ausfd.service
    open5gs-pcfd.service
    open5gs-nssfd.service
    open5gs-amfd.service
    open5gs-smfd.service
    open5gs-upfd.service
    open5gs-scpd.service
    open5gs-webui.service
    # Add other Open5GS services if you are running them
)

for SERVICE in "${SERVICES[@]}"; do
    echo "Starting $SERVICE..."
    sudo systemctl start "$SERVICE"
    if [ $? -eq 0 ]; then
        echo "$SERVICE started successfully."
    else
        echo "Failed to start $SERVICE. Check logs for details."
    fi
done

echo "Open5GS services start sequence complete."
echo "You can check their status with: sudo systemctl status open5gs-*"
echo "Or view logs for a specific service: sudo journalctl -u open5gs-amfd -f"
