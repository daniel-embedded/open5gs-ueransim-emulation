# Open5GS & UERANSIM Single Machine 5G Core Network Emulation

This repository documents a functional 5G Core Network (5GC) emulation environment running on a single machine, utilizing Open5GS as the core network and UERANSIM for the gNodeB (gNB) and User Equipment (UE) simulation. The setup is designed for simplicity, maintaining internal IP addressing and a single UPF, while incorporating architectural elements inspired by the s5uishida sample configuration, particularly regarding Service Communication Proxy (SCP) delegation.

## Table of Contents

1.  [Project Overview](#project-overview)
2.  [Prerequisites](#prerequisites)
3.  [Installation Guide](#installation-guide)
    * [Open5GS Installation](#open5gs-installation)
    * [UERANSIM Installation](#ueransim-installation)
    * [MongoDB Installation](#mongodb-installation)
4.  [Configuration](#configuration)
    * [Open5GS Configuration](#open5gs-configuration)
    * [UERANSIM Configuration](#ueransim-configuration)
    * [UE Registration](#ue-registration)
5.  [Network Setup and Operation](#network-setup-and-operation)
    * [Repository File Structure](#repository-file-structure)
    * [Synchronizing Configuration Files](#synchronizing-configuration-files)
    * [Starting the Network](#starting-the-network)
    * [Stopping the Network](#stopping-the-network)
6.  [Verification](#verification)
7.  [Logs](#logs)
8.  [Troubleshooting Tips](#troubleshooting-tips)
9.  [References](#references)

---

## 1. Project Overview

This setup provides a basic yet complete 5G SA (Standalone) network emulation on a single Linux machine. Key features include:

* **Open5GS**: Provides the 5G Core Network functions (AMF, SMF, UPF, NRF, UDM, UDR, AUSF, PCF, NSSF, SCP, SGW-C, SGW-U, WebUI).
* **UERANSIM**: Simulates a 5G gNB and multiple UEs, connecting to the Open5GS core.
* **Single Machine Deployment**: All components run on the same host, using loopback interfaces for inter-NF communication.
* **SCP Delegation**: Network Functions are configured to delegate SBI (Service-Based Interface) communication through the SCP, simplifying NF discovery and interaction, a pattern seen in more complex deployments like s5uishida's samples.
* **Internal IP Addressing**: UEs receive IP addresses from an internal `10.45.0.0/16` subnet, managed by Open5GS.
* **PLMN ID**: Network operates with PLMN ID 999/70.
* **Automation Scripts**: Bash scripts are provided to streamline the startup and shutdown of Open5GS services and UERANSIM components.

## 2. Prerequisites

* **Operating System**: Ubuntu (tested on Ubuntu 22.04 LTS).
* **Sudo Privileges**: Required for installation and managing system services.
* **Git**: For cloning this repository and managing versions.
    $ sudo apt update
    $ sudo apt install git

* **Open5GS Dependencies**: MongoDB, Node.js (for WebUI).
* **UERANSIM Dependencies**: Build tools (gcc, g++, make), Flex, Bison, CMake.

## 3. Installation Guide

The installation procedures are primarily based on the official Open5GS Quickstart guide and detailed steps from Lapsi/UFCG.

### Open5GS Installation

[cite_start]Open5GS was installed using its official package manager repository. [cite: 1]

1.  **Add Open5GS repository and install:**
    $ sudo add-apt-repository ppa:open5gs/latest
    $ sudo apt update
    $ sudo apt install open5gs

2.  [cite_start]**Install Open5GS WebUI:** The WebUI facilitates UE subscription management and monitoring. [cite: 1]
    $ sudo apt install open5gs-webui


### UERANSIM Installation

[cite_start]UERANSIM was installed by cloning its source code and building it, following the Lapsi/UFCG guide. [cite: 2]

1.  **Install UERANSIM dependencies:**
    $ sudo apt update
    $ sudo apt install make gcc g++ libsctp-dev lksctp-tools cmake libyaml-dev

2.  **Clone UERANSIM and build:**
    $ git clone [https://github.com/UERANSIM/UERANSIM.git](https://github.com/UERANSIM/UERANSIM.git) ~/UERANSIM
    $ cd ~/UERANSIM
    $ make


### MongoDB Installation

MongoDB is a prerequisite for Open5GS to store subscriber data and other network function information. It is automatically installed as a dependency when installing Open5GS via the package manager. Ensure it is running:

    $ sudo systemctl status mongodb

4. Configuration
The configuration of Open5GS and UERANSIM is crucial for their interoperation. The .yaml files in this repository (open5gs_configs/ and ueransim_configs/) represent the working configuration for this setup, adapted from the Lapsi/UFCG guides and s5uishida's samples. 

Open5GS Configuration
The Open5GS network functions are configured to communicate using loopback IP addresses (e.g., 127.0.0.x). A key aspect of this setup is the utilization of the Service Communication Proxy (SCP) for delegated SBI communication.

Main IPs:
    NRF: 127.0.0.10
    SCP: 127.0.0.200
    AMF: 127.0.0.5
    SMF: 127.0.0.4
    UPF: 127.0.0.7
    AUSF: 127.0.0.11
    UDM: 127.0.0.12
    UDR: 127.0.0.20
    PCF: 127.0.0.13
    NSSF: 127.0.0.14
    WebUI: localhost:9999

SCP Delegation: All core NFs (AMF, SMF, AUSF, UDM, UDR, PCF, NSSF) are configured to use the SCP (http://127.0.0.200:7777) as their client for SBI communications, instead of directly querying the NRF. The SCP, in turn, communicates with the NRF (http://127.0.0.10:7777). This is configured by having sbi.client.scp.uri uncommented and pointing to the SCP in each NF's .yaml file.

PLMN ID and TAC: The network operates with PLMN ID 999/70 and TAC 1. This is defined in amf.yaml, nrf.yaml, and aligned with UERANSIM configurations.

DNN and IP Pool: The primary Data Network Name (DNN) is internet. UEs obtain IPv4 addresses from the 10.45.0.0/16 subnet, with 10.45.0.1 as the gateway on the ogstun interface, as configured in smf.yaml and upf.yaml.

Configuration Files: The Open5GS configuration files (*.yaml) are located in /etc/open5gs/. The versions provided in this repository under open5gs_configs/ should be copied to this location.

UERANSIM Configuration
UERANSIM configuration files are located in ~/UERANSIM/config/.

gNB Configuration (gnb1.yaml): Configured to connect to the AMF at 127.0.0.5.

UE Configurations (ue1.yaml to ue5.yaml): Each UE is configured with a unique SUPI (e.g., imsi-999700000000001 for ue1) and points to the gNB.

UE Registration
User Equipment (UE) registration and subscription data are managed through the Open5GS WebUI. 

Access the WebUI at http://localhost:9999.

Navigate to the Subscriber Management section.

Add subscribers with SUPIs corresponding to your UERANSIM UE configurations (e.g., imsi-999700000000001 to imsi-999700000000005).

Ensure each UE has an associated internet DNN.

5. Network Setup and Operation
Repository File Structure
your-open5gs-ueransim-repo/
├── README.md                          # This file
├── open5gs_configs/
│   ├── amf.yaml
│   ├── smf.yaml
│   ├── upf.yaml
│   ├── nrf.yaml
│   ├── scp.yaml
│   ├── ausf.yaml
│   ├── udm.yaml
│   ├── udr.yaml
│   ├── pcf.yaml
│   └── nssf.yaml
├── ueransim_configs/
│   ├── gnb1.yaml
│   ├── ue1.yaml
│   ├── ue2.yaml
│   ├── ue3.yaml
│   ├── ue4.yaml
│   └── ue5.yaml
├── scripts/
│   ├── start_open5gs.sh               # Script to start Open5GS services
│   ├── stop_open5gs.sh                # Script to stop Open5GS services
│   └── start_ueransim.sh              # Script to start UERANSIM gNB and UEs
└── logs/
    ├── open5gs_status_all.log         # Example output of Open5GS service status
    ├── open5gs_amfd_log_all_ues.log   # Example AMF logs for UE registration
    ├── open5gs_smfd_log_all_ues.log   # Example SMF logs for PDU session setup
    ├── open5gs_upfd_log_all_ues.log   # Example UPF logs for UPF session creation
    ├── ueransim_gnb1_log.log          # Example UERANSIM gNB logs
    ├── ueransim_ue1_log.log           # Example UERANSIM UE1 logs
    ├── ueransim_ue5_log.log           # Example UERANSIM UE5 logs (or others)
    └── network_interfaces_ifconfig.log # Example ifconfig output

Synchronizing Configuration Files
Before starting the network, ensure the configuration files from this repository are in their correct system locations:

Open5GS: Copy files from open5gs_configs/ to /etc/open5gs/.
    $ sudo cp ./open5gs_configs/*.yaml /etc/open5gs/

UERANSIM: Copy files from ueransim_configs/ to ~/UERANSIM/config/.
    $ cp ./ueransim_configs/*.yaml ~/UERANSIM/config/

Important: Any changes made to the configuration files in this repository must be copied back to their respective system locations, and the relevant services restarted, for the changes to take effect.

Starting the Network
Navigate to the scripts directory:
    $ cd /path/to/your-open5gs-ueransim-repo/scripts/

Make scripts executable:
    $ chmod +x start_open5gs.sh stop_open5gs.sh start_ueransim.sh

Start Open5GS services:
    $ sudo ./start_open5gs.sh
    (Refer to start_open5gs.sh for the exact list of services started.)

Start UERANSIM gNB and UEs:
    $ sudo ./start_ueransim.sh
    (This script will launch gNB and UEs. By default, it uses nohup to run them in the background with output redirected to log files in the current directory. You can uncomment the gnome-terminal lines in the script if you prefer new terminal windows for live output.)

Stopping the Network
Navigate to the scripts directory:
    $ cd /path/to/your-open5gs-ueransim-repo/scripts/
Stop Open5GS services:
    $ sudo ./stop_open5gs.sh
    (Refer to stop_open5gs.sh for the exact list of services stopped.)

Stop UERANSIM components: If you used nohup to run them in the background, you'll need to kill the processes. You can find their PIDs using ps aux | grep nr-gnb or ps aux | grep nr-ue and then sudo kill <PID>.

6. Verification
After starting the network, verify its operation using the following methods:

Check Open5GS Service Status: Confirm all Open5GS daemons are active (running). 
    $ sudo systemctl status open5gs-*

Monitor Open5GS Logs: Observe real-time logs for UE registration, PDU session establishment, and internal NF communication. 
    $ sudo journalctl -u open5gs-amfd -f   # For AMF logs
    $ sudo journalctl -u open5gs-smfd -f   # For SMF logs
    $ sudo journalctl -u open5gs-upfd -f   # For UPF logs
    $ # You can check other services like nssfd, scpd, udmd, udrd, pcfd, ausfd

Check UERANSIM Logs: Verify gNB's NG Setup success and UE's successful registration and PDU session establishment. 
    $ # If running in foreground, observe terminal output.
    $ # If running with nohup, check the log files in your scripts/ directory:
    $ tail -f ueransim_gnb1.log
    $ tail -f ueransim_ue1.log
    $ tail -f ueransim_ue5.log # And for other UEs
    Look for lines indicating "NG Setup procedure is successful", "Initial Registration is successful", and "Connection setup for PDU session[1] is successful, TUN interface[uesimtunX, 10.45.0.Y] is up." 

Verify Network Interfaces: Confirm that ogstun and uesimtunX interfaces are created and have the expected IP addresses. 
    $ ifconfig
    Expected interfaces include ogstun (e.g., 10.45.0.1, 2001:db8:cafe::1), and uesimtun0 through uesimtun4 (e.g., 10.45.0.2, 10.45.0.3, etc.). 

7. Logs
    Example log outputs demonstrating successful operation are included in the logs/ directory of this repository. These logs capture critical messages during network startup, UE registration, and PDU session establishment from various components.

8. Troubleshooting Tips
    Service Status: Always start by checking sudo systemctl status open5gs-* to ensure all core network functions are running.
    Firewall: Ensure your firewall (e.g., ufw) is not blocking necessary ports. Open5GS uses various ports for SBI (7777), PFCP (8805), GTP (2152), and NGAP (38412).
    Configuration Mismatches: Small typos or incorrect IP addresses in .yaml files are common culprits. Double-check addresses, PLMN IDs, and port numbers.
    MongoDB: Verify MongoDB is running and accessible if you encounter issues with UE data.
    UERANSIM Permissions: nr-gnb and nr-ue require sudo to create tunnel interfaces. Ensure you run them with sudo.
    Log Analysis: The journalctl and UERANSIM log files (if running with nohup) are your best friends for debugging. Look for ERROR or WARNING messages.

9. References
Open5GS Quickstart Guide: https://open5gs.org/open5gs/docs/guide/01-quickstart/
Lapsi/UFCG Installation Guides:
    Open5GS: https://laps.dee.ufcg.edu.br/laborat%C3%B3rio-5g/instala%C3%A7%C3%A3o/open5gs
    UERANSIM: https://laps.dee.ufcg.edu.br/laborat%C3%B3rio-5g/instala%C3%A7%C3%A3o/ueransim
Lapsi/UFCG Configuration Guides:
    Open5GS: https://laps.dee.ufcg.edu.br/laborat%C3%B3rio-5g/configura%C3%A7%C3%A3o/open5gs
    UERANSIM: https://laps.dee.ufcg.edu.br/laborat%C3%B3rio-5g/configura%C3%A7%C3%A3o/ueransim
    UE Registration: https://laps.dee.ufcg.edu.br/laborat%C3%B3rio-5g/configura%C3%A7%C3%A3o/cadastro-de-ue
s5uishida Open5GS/UERANSIM Sample Config: https://github.com/s5uishida/open5gs_5gc_ueransim_sample_config
