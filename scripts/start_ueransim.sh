#!/bin/bash

# This script starts UERANSIM gNB and UE instances.
# Each component will run in a separate terminal or in the background.
# Adjust paths to UERANSIM build directory and config files as needed.
# Run this script with sudo: sudo ./start_ueransim.sh

UERANSIM_BUILD_DIR="/home/dhmm/UERANSIM/build" # Adjust this path
UERANSIM_CONFIG_DIR="/home/dhmm/UERANSIM/config" # Adjust this path

echo "Starting UERANSIM gNB and UEs..."

# Start gNB (gnb1.yaml)
echo "Starting gNB (gnb1.yaml) in a new terminal window..."
# Option 1: Open in a new terminal (works with gnome-terminal, adjust for others)
# gnome-terminal --tab --title="UERANSIM gNB 1" -- bash -c "sudo ${UERANSIM_BUILD_DIR}/nr-gnb -c ${UERANSIM_CONFIG_DIR}/gnb1.yaml; exec bash" &

# Option 2: Run in background using nohup (output redirected to gnb1.log)
# Ensure you have the config file copied to the UERANSIM_CONFIG_DIR if you are using your GitHub repo copies
sudo nohup ${UERANSIM_BUILD_DIR}/nr-gnb -c ${UERANSIM_CONFIG_DIR}/gnb1.yaml > ueransim_gnb1.log 2>&1 &
echo "gNB process started in background. Check ueransim_gnb1.log for output."
echo "PID: $!"

# Start gNB (gnb2.yaml)
echo "Starting gNB (gnb2.yaml) in a new terminal window..."
# Option 1: Open in a new terminal (works with gnome-terminal, adjust for others)
# gnome-terminal --tab --title="UERANSIM gNB 2" -- bash -c "sudo ${UERANSIM_BUILD_DIR}/nr-gnb -c ${UERANSIM_CONFIG_DIR}/gnb2.yaml; exec bash" &

# Option 2: Run in background using nohup (output redirected to gnb2.log)
# Ensure you have the config file copied to the UERANSIM_CONFIG_DIR if you are using your GitHub repo copies
sudo nohup ${UERANSIM_BUILD_DIR}/nr-gnb -c ${UERANSIM_CONFIG_DIR}/gnb2.yaml > ueransim_gnb2.log 2>&1 &
echo "gNB process started in background. Check ueransim_gnb2.log for output."
echo "PID: $!"

# Start UE1 (ue1.yaml)
echo "Starting UE1 (ue1.yaml) in a new terminal window..."
# Option 1: Open in a new terminal
# gnome-terminal --tab --title="UERANSIM UE 1" -- bash -c "sudo ${UERANSIM_BUILD_DIR}/nr-ue -c ${UERANSIM_CONFIG_DIR}/ue1.yaml; exec bash" &

# Option 2: Run in background using nohup
sudo nohup ${UERANSIM_BUILD_DIR}/nr-ue -c ${UERANSIM_CONFIG_DIR}/ue1.yaml > ueransim_ue1.log 2>&1 &
echo "UE1 process started in background. Check ueransim_ue1.log for output."
echo "PID: $!"

# Start UE2 (ue2.yaml)
echo "Starting UE2 (ue2.yaml) in a new terminal window..."
# Option 1: Open in a new terminal
# gnome-terminal --tab --title="UERANSIM UE 2" -- bash -c "sudo ${UERANSIM_BUILD_DIR}/nr-ue -c ${UERANSIM_CONFIG_DIR}/ue2.yaml; exec bash" &

# Option 2: Run in background using nohup
sudo nohup ${UERANSIM_BUILD_DIR}/nr-ue -c ${UERANSIM_CONFIG_DIR}/ue2.yaml > ueransim_ue2.log 2>&1 &
echo "UE2 process started in background. Check ueransim_ue2.log for output."
echo "PID: $!"

# Start UE3 (ue3.yaml)
echo "Starting UE3 (ue3.yaml) in a new terminal window..."
# Option 1: Open in a new terminal
# gnome-terminal --tab --title="UERANSIM UE 3" -- bash -c "sudo ${UERANSIM_BUILD_DIR}/nr-ue -c ${UERANSIM_CONFIG_DIR}/ue3.yaml; exec bash" &

# Option 2: Run in background using nohup
sudo nohup ${UERANSIM_BUILD_DIR}/nr-ue -c ${UERANSIM_CONFIG_DIR}/ue3.yaml > ueransim_ue3.log 2>&1 &
echo "UE3 process started in background. Check ueransim_ue3.log for output."
echo "PID: $!"

# Start UE4 (ue4.yaml)
echo "Starting UE4 (ue4.yaml) in a new terminal window..."
# Option 1: Open in a new terminal
# gnome-terminal --tab --title="UERANSIM UE 4" -- bash -c "sudo ${UERANSIM_BUILD_DIR}/nr-ue -c ${UERANSIM_CONFIG_DIR}/ue4.yaml; exec bash" &

# Option 2: Run in background using nohup
sudo nohup ${UERANSIM_BUILD_DIR}/nr-ue -c ${UERANSIM_CONFIG_DIR}/ue4.yaml > ueransim_ue4.log 2>&1 &
echo "UE4 process started in background. Check ueransim_ue4.log for output."
echo "PID: $!"


# Start UE5 (ue5.yaml)
echo "Starting UE5 (ue5.yaml) in a new terminal window..."
# Option 1: Open in a new terminal
# gnome-terminal --tab --title="UERANSIM UE 5" -- bash -c "sudo ${UERANSIM_BUILD_DIR}/nr-ue -c ${UERANSIM_CONFIG_DIR}/ue5.yaml; exec bash" &

# Option 2: Run in background using nohup
sudo nohup ${UERANSIM_BUILD_DIR}/nr-ue -c ${UERANSIM_CONFIG_DIR}/ue5.yaml > ueransim_ue5.log 2>&1 &
echo "UE5 process started in background. Check ueransim_ue5.log for output."
echo "PID: $!"

echo "UERANSIM components start sequence initiated."
echo "If running in background, monitor respective log files (e.g., ueransim_gnb1.log)."
echo "You can find PIDs for background processes above if needed for manual killing (e.g., kill <PID>)."
