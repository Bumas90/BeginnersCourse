#!/bin/bash
 
# ************************************************************************
# function 4 my sqlserver config
#

configure_mysqlserver() {
    sudo sed -i -e '1,$s/bind\-address.*127\.0\.0\.1/bind\-address\ \ \=\ 0\.0\.0\.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
    
	# replaced by reboot at eof:
	# sudo systemctl restart mysql
}

# ************************************************************************
# configure server
#
 
sudo date
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
sudo date
sudo date -u

# ************************************************************************
# remove apparmor
#

sudo systemctl stop apparmor
sudo systemctl disable apparmor
sudo apt purge apparmor -y
sudo rm -r /ect/apparmor*
sudo chattr -i /mnt/DATALOSS_WARNING_README.txt
sudo rm /mnt/DATALOSS_WARNING_README.txt


# ************************************************************************
# prep log partition
#

sudo mkdir -p /mnt/mysql/binlog
sudo mkdir -p /mnt/mysql/relaylog
sudo chmod -R 750 /mnt/mysql
sudo chown -R mysql:mysql /mnt/mysql

# ************************************************************************
# configure admin user
#

sudo apt install mysql-server-5.7 -y
sudo mkdir -p /var/run/mysqld
sudo chown mysql:mysql /var/run/mysqld
sudo systemctl enable mysql
sudo systemctl restart mysql
sudo echo "CREATE USER 'sqladmin'@'%' IDENTIFIED BY 'blackmaria';" | mysql -u root
sudo echo "GRANT ALL on *.* TO 'sqladmin'@'%' WITH GRANT OPTION;" | mysql -u root
sudo echo "FLUSH PRIVILEGES;" | mysql -u root

# ************************************************************************
# server config
#

configure_mysqlserver
# sudo reboot