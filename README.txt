Elrond real-time node performance and health monitoring with Zabbix & Grafana
powered by Disruptive Digital (c) 2020-2021
Big thanks to Jose from The Palm Tree Network for the wonderful installation guide: https://bagpipe-plantain-lgtp.squarespace.com/zabbix-elrond-guide
Big thanks also to Vasile Radu from Arc Stake, Mihai Eremia from Trust Staking, Dr. Delphi from Staking Agency for all the help they provided


These scripts install Zabbix server, Zabbix agent, Grafana server and automates all the necessary configurations to properly monitor your Elrond nodes.

Make sure you have git installed, if not, run the following commands:
sudo apt update
sudo apt install git

Zabbix server installation:
cd ~ && git clone https://github.com/disruptivedigital/dd-zabbix-server-agent-grafana-install.git && cd dd-zabbix-server-agent-grafana-install && bash dd-zabbix-server-install-config.sh

Zabbix agent installation:
cd ~ && git clone https://github.com/disruptivedigital/dd-zabbix-server-agent-grafana-install.git && cd dd-zabbix-server-agent-grafana-install && bash dd-zabbix-agent-install-config.sh

Grafana server installation:
cd ~ && git clone https://github.com/disruptivedigital/dd-zabbix-server-agent-grafana-install.git && cd dd-zabbix-server-agent-grafana-install && bash dd-grafana-server-install-config.sh
