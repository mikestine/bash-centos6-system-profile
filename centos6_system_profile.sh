#!/bin/bash

# '%b' Print interprets backslash escapes (doesn't treat backslashes like strings)
function log {
	printf '%b' "$@"
}

function usage {
cat <<HEREDOC
##################################################################################
#       Title: CentOS6 System Profile
#        File: centos6_system_profile.sh
#      Author: Mike Stine
#        Date: 20181018  
#     Version: 1.0 
# Description: Profiles a machine running CentOS6.  Prints OS and hardware 
#              information including: hostname, network, chassis, bios, processor,
#              memory, block device, mounted file system, system slots.
#       Usage: ./centos6_system_profile.sh
#              or to execute script remotely
#              ssh -p22 root@10.102.1.111 "bash -s" -- < centos6_system_profile.sh
##################################################################################

HEREDOC
}

function get_system_profile {

	log "############  System Information  ############\n"
	log "\tHost Name: $(hostname)\n"
	log "\tBorn On: $(ls -lact --full-time /etc/ | awk 'END {print $6,$7,$8}')\n"
	log "\tCentOS Release: $(cat /etc/centos-release)\n"
	log "\tKernel Name: $(uname -s)\n"
	log "\tKernel Release: $(uname -r)\n"
	log "\tKernel Version: $(uname -v)\n"
	log "\tMachine Hardware Name: $(uname -m)\n"
	log "\tProcessor Type: $(uname -p)\n"
	log "\tHardware Platform: $(uname -i)\n"
	log "\tOperating System: $(uname -i)\n\n"

	# Network Info
	log "############  Network Information  ############\n"
	log "$(ifconfig | grep -A1 'encap:' )\n\n"
	
	# Chassis Information
	log "############  Chassis Information  ############\n"
	log "$(dmidecode --type chassis| grep -E 'Type:|Height:|Number Of Power Cords:')\n"
	log "$(dmidecode --type system| grep -E 'Manufacturer:|Product Name:|Version:|Serial Number:|UUID:|SKU Number:|Family:')\n\n"
	
	# BIOS Information
	log "############  BIOS Information  ############\n"
	log "$(dmidecode --type bios | grep -E 'Vendor:|Version:|Release Date:|Firmware Revision:')\n\n"
	
 	# Processor Information
	log "############  Processor Information  ############\n" 
 	log "\tSockets Total: $(cat /proc/cpuinfo | grep "physical id" | sort -u | wc -l)\n"
 	log "\tSockets Used: $(lscpu | grep -E '^Socket' | grep -oE '[0-9]+')\n"
	log "\tCores per Socket: $(lscpu | grep -E '^Core' | grep -oE '[0-9]+')\n"
	log "\tThreads per Core: $(lscpu | grep -E '^Thread' | grep -oE '[0-9]+')\n"
	log "\tCPUs: $(lscpu | grep -E '^CPU\(s\)' | grep -oE '[0-9]+')\n" 
	log "\tArchitecture: $(lscpu | grep -E '^Architecture:' | grep -oE 'x[0-9].+')\n" 
	log "\t$(lscpu | grep -E 'Model name:')\n" 
	log "\tCPU MHz:$(lscpu | grep -E 'CPU MHz:' | grep -oE '[\.[0-9]+')\n\n" 
	
	# Memory Information
	log "############  Memory Information  ############\n"
	log "\t$(awk '$3=="kB"{$2=$2/1024;$3="MB"} 1' /proc/meminfo | grep 'MemTotal:')\n"
	log "\tSlots Total: $(dmidecode -t memory | grep '^Memory Device$' | wc -l)\n"
	log "\tSlots Used: $(dmidecode -t memory | grep -E 'Size: [0-9]+' | wc -l)\n"
	log "$(dmidecode -t memory | grep -A14 -E 'Size: [0-9]+' | grep -E 'Size:|Locator:|Type:|Speed:|Manufacturer:' | sed -e "s/^.*Size:.*$/^^\n&1/" )\n\n"

	# Block Device Information
	log "############  Block Device Information  ############\n"
	log "\tBlock Device Total: $(lsblk -dn | wc -l)\n"
	log "$(lsblk)\n\n"

	# Mounted File Systems
	log "############  Mounted File Systems  ############\n"
	log "$(df -h --total)\n\n"

	# System Slot Information
	log "############  System Slot Information  ############\n"
	log "\tSlots Free: $(dmidecode --type slot | grep 'Available' | wc -l )\n"
	log "\tSlots Used: $(dmidecode --type slot | grep 'In Use' | wc -l )\n\n"
	log "$(dmidecode --type slot | grep -A 3 'Designation'  )\n\n"

	# Aspera Enterprise Information
	log "############  Aspera License Information  ############\n"
	log "$(ascp -DD -A)\n\n"

	# Aspera Console Information
	if [ -e "$/opt/aspera/console/.version" ]; then
		log "############  Aspera Console Version  ############\n"
		log "$(cat /opt/aspera/console/.version)\n\n"
	fi

}

function main {
	#usage
	get_system_profile
	exit 0
}

main