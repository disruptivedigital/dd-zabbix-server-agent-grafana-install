#!/bin/bash
# Zabbix Server Installation & config script - Mainnet Elrond Nodes
# powered by Disruptive Digital (c) 2020-2021 | join our tech telegram group here https://t.me/disruptivedigital_vtc
# Big thanks to Jose from The Palm Tree Network for the wonderful installation guide: https://bagpipe-plantain-lgtp.squarespace.com/zabbix-elrond-guide
# Big thanks also to Mihai Eremia from Trust Staking, Dr. Delphi from Staking Agency, Vasile Radu from Arc Stake, for all the help they provided
# v.1.0

# INSTALLING APACHE2
sudo apt update
sudo apt install apache2
sudo systemctl start apache2
sudo systemctl enable apache2
#sudo systemctl status apache2

# INSTALLING PHP PACKAGES & PERFORM PHP CONFIGURATION 
sudo apt install php-cli php-common php-dev php-pear php-gd php-mbstring php-mysql php-xml php-bcmath libapache2-mod-php
# - Backing up the files
cd /etc/php/7*/apache2/ && sudo cp php.ini php.ini.bak
cd /etc/php/7*/cli/ && sudo cp php.ini php.ini.bak
printf "\nPlease specify your timezone (default: Europe/Bucharest).\n List of Supported Timezones available here: https://www.php.net/manual/en/timezones.php \nYour timezone (or leave it blank for default: )"
read tzone
if [ -n "$tzone" ]; then
	printf "\nTimezone = $tzone\n"
	dtzone=("date.timezone = "$tzone)
else
	tzone=("Europe/Bucharest")
	printf "\nTimezone = $tzone\n"
	dtzone=("date.timezone = "$tzone)
	
fi
sudo sed -i "s|date.timezone =|$dtzone|" /etc/php/7*/apache2/php.ini /etc/php/7*/cli/php.ini
sudo sed -i "s/max_execution_time = 30/max_execution_time = 600/" /etc/php/7*/apache2/php.ini /etc/php/7*/cli/php.ini
sudo sed -i "s/max_input_time = 60/max_input_time = 600/" /etc/php/7*/apache2/php.ini /etc/php/7*/cli/php.ini
sudo sed -i "s/memory_limit = 128M/memory_limit = 256M/" /etc/php/7*/apache2/php.ini /etc/php/7*/cli/php.ini
sudo sed -i "s/post_max_size = 8M/post_max_size = 25M/" /etc/php/7*/apache2/php.ini /etc/php/7*/cli/php.ini
sudo sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 16M/" /etc/php/7*/apache2/php.ini /etc/php/7*/cli/php.ini

sudo systemctl restart apache2

# INSTALLING ZABBIX REPOSITORIES
# Query which Zabbix version to install
# Declare variable zver and assign value 0
printf "\nChoose your Ubuntu version \n"
zver=0
# Print to stdout
printf "\n1. Ubuntu 20.04 (Focal)"
printf "\n2. Ubuntu 18.04 (Bionic)"
printf "\nPlease choose your Ubuntu version [1 or 2]? "
# Loop while the variable zver is equal 0
# bash while loop
while [ $zver -eq 0 ]; do
# read user input
read zver
# bash nested if/else
if [ $zver -eq 1 ] ; then
        printf "\nYou selected Ubuntu 20.04 (Focal)\n"
		echo "Installing Zabbix Server v5.0 LTS for Ubuntu 20.04 (Focal) - web server APACHE2"
		sudo wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb
		sudo dpkg -i zabbix-release_5.0-1+focal_all.deb
else
        if [ $zver -eq 2 ] ; then
					printf "\nYou selected Ubuntu 18.04 (Bionic)\n"
					echo "Installing Zabbix Server v5.0 LTS for Ubuntu 18.04 (Bionic) - web server APACHE2"
					sudo wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+bionic_all.deb
					sudo dpkg -i zabbix-release_5.0-1+bionic_all.deb
				
        else
                        printf "\nPlease make a choice between 1-2!"
                        printf "\n1. Ubuntu 20.04 (Focal)"
                        printf "\n2. Ubuntu 18.04 (Bionic)"
                        printf "\nPlease choose your Ubuntu version [1 or 2]?"
                        zver=0
        fi
fi
done

sudo apt update


# INSTALLING PACKAGES
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent zabbix-get mysql-server -y

# CONFIGURING DATABASE
sudo systemctl start mysql
printf "\nCreating zabbix MySQL database, creating user 'zabbix'@'localhost', grating all privileges on zabbix.* to 'zabbix'@'localhost'...\n"
printf "\nPlease set MySQL database password (avoid GLOB - wildcard - characters): "
read -s zsqlpass
sudo mysql -uroot << EOF
create database zabbix character set utf8 collate utf8_bin;
create user 'zabbix'@'localhost' identified by '$zsqlpass';
grant all privileges on zabbix.* to 'zabbix'@'localhost';
show databases;
EOF
# - Backing up the files
cd /etc/zabbix/ && sudo cp zabbix_server.conf zabbix_server.conf.bak && sudo cp apache.conf apache.conf.bak
# Config database & files
printf "\nPlease confirm your newly created MySQL database password. \n"
sudo zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix
sudo sed -i "s/# DBPassword=/DBPassword=$zsqlpass/" /etc/zabbix/zabbix_server.conf
sudo systemctl start zabbix-server
sudo systemctl enable zabbix-server # sudo systemctl status zabbix-server
phptzone=("php_value date.timezone "$tzone)
sudo sed -i "s|# php_value date.timezone Europe/Riga|$phptzone|" /etc/zabbix/apache.conf
sudo systemctl restart apache2


# Setting the firewall for Zabbix server
ufwstatus=/etc/ufw/ufw.conf

if [ -f "$ufwstatus" ]; then
    echo "Opening ports 80, 443, 10050 and 10051 to be able to remote access your Zabbix server..."
	sudo ufw allow 80,443,10050,10051/tcp
else
    echo "UFW is not installed. No ports were opened. In case you have another firewall installed, the following ports must be opened in order to access your Zabbix server: 80, 443, 10050 and 10051."
fi

myextip="$(curl ifconfig.me)"
printf "\nZabbix Server successfully installed.\nAccess your Zabbix server here: http://${myextip}/zabbix\n"
