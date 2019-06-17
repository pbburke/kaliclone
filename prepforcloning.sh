#!/usr/bin/env bash
#script for kali cloneable image
#adapted from https://everythingshouldbevirtual.com/virtualization/ubuntu-vmware-template-cleanup-script/

#Stop services for cleanup
service rsyslog stop

#clear audit logs
if [ -f /var/log/audit/audit.log ]; then
    cat /dev/null > /var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
    cat /dev/null > /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    cat /dev/null > /var/log/lastlog
fi

#cleanup persistent udev rules
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
    rm /etc/udev/rules.d/70-persistent-net.rules
fi

#cleanup /tmp directories
rm -rf /tmp/*
rm -rf /var/tmp/*

#cleanup current ssh keys
rm -f /etc/ssh/ssh_host_*

#reset hostname
cat /dev/null > /etc/hostname

#add line to set a new unique hostname based on MAC
#this will set the hostname on EVERY boot, which is fine because of the nature of the class
echo \@reboot hostnamectl set-hostname IT-$(ip -o link  | awk '{print $2,$(NF-2)}' | grep eth0 | cut -d " " -f 2 | sed s/://g) >> /etc/rc.local

#cleanup apt
apt update
apt dist-upgrade -y
apt-get clean

#cleanup shell history
history -w
history -c
