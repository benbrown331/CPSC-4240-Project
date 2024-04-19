#!/bin/bash

#This should allow the administrator to restrict the sudo priviledges of certain users 
#to whatever time window the admin decides

#First, ensure the user runs the script as root. If not, the program will not do anything.


#Configure sudo to use the pam_time module
#The pam_time time module is typically used to restrict login times,
#but the sudo file does not use it

function pam_time_sudo() {
	#Create local var with path to sudo file
	local pam_sudo_file="/etc/pam.d/sudo"
	
	if ! grep -q "pam_time.so" "$pam_sudo_file"; then
		#Append pam_time.so to file if it is not found
		echo "account required pam_time.so" >> $pam_sudo_file
	fi
}

#Add the time restriction to time.conf
function time_conf() {
	local time_conf_file="/etc/security/time.conf"
	
	echo "Adding time restriction for user $1 with access times $2"
	
	echo "sudo;*;$1;$2" >> "$time_conf_file"
}

echo "This script will limit elevated priviledges (sudo) to certain time windows depending on the user"

read -p "Enter the username to restrict: " username

read -p "Enter the allowed access times (Ex. MoFr0900-1700): " access_times

pam_time_sudo

time_conf "$username" "$access_times"

echo "Configuration complete."	

