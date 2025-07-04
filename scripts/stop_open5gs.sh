#!/bin/bash

# This script stops all Open5GS services.
# Run this script with sudo: sudo ./stop_open5gs.sh

echo "Stopping Open5GS services..."

# List of Open5GS services to stop (reverse order of starting is often good practice)
SERVICES=(
    open5gs-webui.service
    open5gs-scpd.service
    open5gs-upfd.service
    open5gs-smfd.service
    open5gs-amfd.service
    open5gs-nssfd.service
    open5gs-pcfd.service
    open5gs-ausfd.service
    open5gs-udmd.service
    open5gs-udrd.service
    open5gs-nrfd.service
    # Add other Open5GS services if you are running them
)

for SERVICE in "${SERVICES[@]}"; do
    echo "Stopping $SERVICE..."
    sudo systemctl stop "$SERVICE"
    if [ $? -eq 0 ]; then
        echo "$SERVICE stopped successfully."
    else
        echo "Failed to stop $SERVICE. Check logs for details."
    fi
done

echo "Open5GS services stop sequence complete."
echo "You can check their status with: sudo systemctl status open5gs-*"
