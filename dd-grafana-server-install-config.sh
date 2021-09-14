#!/bin/bash
# Grafana Installation & config script - Mainnet Elrond Nodes
# powered by Disruptive Digital (c) 2020-2021 | join our tech telegram group here https://t.me/disruptivedigital_vtc
# Big thanks to Jose from The Palm Tree Network for the wonderful tutorial: https://bagpipe-plantain-lgtp.squarespace.com/zabbix-elrond-guide
# Big thanks also to Mihai Eremia from Trust Staking, Dr. Delphi from Staking Agency, Vasile Radu from Arc Stake, for all the help they provided
# v.1.0

# INSTALLING GRAFANA 
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_8.1.2_amd64.deb
sudo dpkg -i grafana_8.1.2_amd64.deb
sudo systemctl start grafana-server
sudo systemctl enable grafana-server # sudo systemctl status grafana-server
sudo grafana-cli plugins install alexanderzobnin-zabbix-app
sudo systemctl restart grafana-server

printf "\nGrafana successfully installed.\n"
