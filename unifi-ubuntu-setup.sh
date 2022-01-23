#!/bin/bash
#Unifi Controller Server Setup

hostName="unifi-cloud"
networkInterface="eth0"
ipAddress="192.168.0.254"
networkMask="24"
gatewayIP="192.168.0.1"
dnsServers='192.168.0.1, 8.8.8.8' 
unifiControlSoftware="https://fw-download.ubnt.com/data/unifi-controller/d41a-debian-6.5.55-1906672766bc49aa990c952117af3dd3.deb"

# Configure Server Static IP Address
sed -i "s/netowrkInterface/$networkInterface/" config/01-netcfg.yaml
sed -i "s/ipAddress/$ipAddress/" config/01-netcfg.yaml
sed -i "s/networkMask/$networkMask/" config/01-netcfg.yaml
sed -i "s/gatewayIPAddress/$gatewayIP/" config/01-netcfg.yaml
sed -i "s/dnsIPAddresses/$dnsServers/" config/01-netcfg.yaml

cp "config/99-disable-network-config.cfg"  "/etc/cloud/cloud.cfg.d/99-disable-network-config.cfg"

cp "config/01-netcfg.yaml"  "/etc/netplan/01-netcfg.yaml"

netplan apply

# Update Server Hostname
currentHostName=(hostnamectl) 
sed -i "s/$currentHostName/$hostName/" "/etc/hosts"

# Update and Upgrade Packages
apt-get update -y
apt-get upgrade -y


# Enable SSH Access
apt-get install -y openssh-server
systemctl enable ssh
service ssh start

# Unifi Controller Install
wget -O unifi_sysvinit_all.deb $unifiControlSoftware
apt-get install -y -f
systemctl enable unifi
service unifi start
allow ssh

# Restart
reboot





