#!/bin/bash
# -------
# Script for install of Mariadb to be used with Alfresco
#
# Copyright 2013-2016 Loftux AB, Peter Löfgren
# Distributed under the Creative Commons Attribution-ShareAlike 3.0 Unported License (CC BY-SA 3.0)
# -------

export ALFRESCODB=alfresco
export ALFRESCOUSER=alfresco

echo
echo "--------------------------------------------"
echo "This script will install MariaDB."
echo "and create alfresco database and user."
echo "You may first be prompted for sudo password."
echo "When prompted during MariaDB Install,"
echo "type the default root password for MariaDB."
echo "--------------------------------------------"
echo

read -e -p "Install MariaDB? [y/n] " -i "n" installmariadb
if [ "$installmariadb" = "y" ]; then
  cat <<EOF > /etc/yum.repos.d/mariadb.repo
# MariaDB 10.3 CentOS repository list - created 2019-04-02 12:41 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3/centos7-ppc64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
  sudo yum -y update
  sudo yum -y install mariadb-server
  systemctl enable mariadb
  systemctl start mariadb
fi

mysql_secure_installation

read -e -p "Create Alfresco Database and user? [y/n] " -i "n" createdb
if [ "$createdb" = "y" ]; then
read -e -p "Enter the Alfresco database password:" ALFRESCOPASSWORD
read -e -p "Re-Enter the Alfresco database password:" ALFRESCOPASSWORD2
if [ "$ALFRESCOPASSWORD" == "$ALFRESCOPASSWORD2" ]
then
  echo "Creating Alfresco database and user."
  echo "You must supply the root user password for MariaDB:"
  mysql -u root -p << EOF
create database $ALFRESCODB default character set utf8 collate utf8_bin;
grant all on $ALFRESCODB.* to '$ALFRESCOUSER'@'localhost' identified by '$ALFRESCOPASSWORD' with grant option;
grant all on $ALFRESCODB.* to '$ALFRESCOUSER'@'localhost.localdomain' identified by '$ALFRESCOPASSWORD' with grant option;
EOF
  echo
  echo "Remember to update alfresco-global.properties with the alfresco database password"
  echo
else
  echo
  echo "Passwords do not match. Please run the script again for better luck!"
  echo
fi
fi
