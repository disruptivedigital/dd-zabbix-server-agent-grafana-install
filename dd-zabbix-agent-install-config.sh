#!/bin/bash
# Zabbix Agent Installation & config script - Mainnet Elrond Nodes
# powered by Disruptive Digital (c) 2020-2021 | join our tech telegram group here https://t.me/disruptivedigital_vtc
# Big thanks to Jose from The Palm Tree Network for the wonderful installation guide: https://bagpipe-plantain-lgtp.squarespace.com/zabbix-elrond-guide
# Big thanks also to Mihai Eremia from Trust Staking, Dr. Delphi from Staking Agency, Vasile Radu from Arc Stake, for all the help they provided
# v.1.0

# FIREWALL RULES
printf "\nPlease specify your Zabbix server IP or host: "
read zsIP

ufwstatus=/etc/ufw/ufw.conf
if [ -f "$ufwstatus" ]; then
    echo "Configure ufw to allow all the connections from the IP of your Zabbix Server ..."
	sudo ufw allow from $zsIP
else
    echo "UFW is not installed. Skipping ufw configuration."
fi


# INSTALLING ZABBIX REPOSITORIES
sudo wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb
sudo dpkg -i zabbix-release_5.0-1+focal_all.deb
sudo apt update

# INSTALLING ZABBIX AGENT & CONFIGURE
sudo apt install zabbix-agent
hname=$(hostname -f)
printf "\nSetting your Zabbix server IP and hostname: $hname \n"
azsIP=("Server="$zsIP)
sazIP=("ServerActive="$zsIP)
zhname=("Hostname="$hname)
sudo sed -i "s|Server=127.0.0.1|$azsIP|" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s|ServerActive=127.0.0.1|$sazIP|" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s|Hostname=Zabbix server|$zhname|" /etc/zabbix/zabbix_agentd.conf

# Zabbix Elrond Metrics
sudo apt install perl
cd ~ && sudo git clone https://github.com/arcsoft-ro/zabbix-elrond-plugin
cd ~/zabbix-elrond-plugin && sudo ./install.pl
sudo systemctl restart zabbix-agent # sudo systemctl status zabbix-agent

printf "\nZabbix Agent successfully installed.\n"