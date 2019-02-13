#!/bin/bash
# -------
# Script for install of Alfresco
#
# Copyright 2013-2017 Loftux AB, Peter Löfgren
# Distributed under the Creative Commons Attribution-ShareAlike 3.0 Unported License (CC BY-SA 3.0)
# -------

export ALF_HOME=/opt/alfresco
export ALF_DATA_HOME=$ALF_HOME/alf_data
export CATALINA_HOME=$ALF_HOME/tomcat
export ALF_USER=alfresco
export ALF_GROUP=$ALF_USER
export YUMVERBOSITY="-y"
export TMP_INSTALL=/tmp/alfrescoinstall
export DEFAULTYESNO="y"

# Branch name to pull from server. Use master for stable.
BRANCH=experimental
export BASE_DOWNLOAD=https://raw.githubusercontent.com/amineyc/AlfrescoCentOSInstaller/$BRANCH
export KEYSTOREBASE=https://svn.alfresco.com/repos/alfresco-open-mirror/alfresco/HEAD/root/projects/repository/config/alfresco/keystore

#Change this to prefered locale to make sure it exists. This has impact on LibreOffice transformations
#export LOCALESUPPORT=sv_SE.utf8
#export LOCALESUPPORT=en_US.utf8
export LOCALESUPPORT=fr_FR.utf8

#Tomcat and JDBC

export TOMCAT_DOWNLOAD=https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.28/bin/apache-tomcat-8.5.28.tar.gz
export JDBCPOSTGRESURL=https://jdbc.postgresql.org/download
export JDBCPOSTGRES=postgresql-42.2.5.jar
export JDBCMYSQLURL=https://dev.mysql.com/get/Downloads/Connector-J
export JDBCMYSQL=mysql-connector-java-5.1.47.tar.gz

#LibreOffice

export LIBREOFFICE=https://downloadarchive.documentfoundation.org/libreoffice/old/5.2.1.2/rpm/x86_64/LibreOffice_5.2.1.2_Linux_x86-64_rpm.tar.gz
export ALFRESCO_PDF_RENDERER=https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/alfresco-pdf-renderer/1.1/alfresco-pdf-renderer-1.1-linux.tgz

# Alfresco CSC War

export ALFREPOWAR=https://downloads.loftux.net/public/content/org/alfresco/content-services-community/6.0.7-ga/content-services-community-6.0.7-ga.war

# Alfresco Share War

export ALFSHAREWAR=https://downloads.loftux.net/public/content/org/alfresco/share/6.0.c/share-6.0.c.war
export ALFSHARESERVICES=https://downloads.loftux.net/public/content/org/alfresco/alfresco-share-services/6.0.c/alfresco-share-services-6.0.c.amp
export ALFMMTJAR=https://downloads.loftux.net/public/content/org/alfresco/alfresco-mmt/6.0/alfresco-mmt-6.0.jar

# Alfresco Search Service

export ASS_DOWNLOAD=https://downloads.loftux.net/public/content/org/alfresco/alfresco-search-services/1.2.0/alfresco-search-services-1.2.0.zip

# Loftux Custome Alfresco

export LXALFREPOWAR=https://downloads.loftux.net/alfresco/alfresco-platform/LX101/alfresco-platform-LX101.war
export LXALFSHAREWAR=https://downloads.loftux.net/alfresco/share/LX101/share-LX101.war
export LXALFSHARESERVICES=https://downloads.loftux.net/alfresco/alfresco-share-services/LX101/alfresco-share-services-LX101.amp

# Alfresco GoogleDocs

export GOOGLEDOCSREPO=https://downloads.loftux.net/public/content/org/alfresco/integrations/alfresco-googledocs-repo/3.0.4.3/alfresco-googledocs-repo-3.0.4.3.amp
export GOOGLEDOCSSHARE=https://downloads.loftux.net/public/content/org/alfresco/integrations/alfresco-googledocs-share/3.0.4.3/alfresco-googledocs-share-3.0.4.3.amp

# Alfresco AOS

export AOS_VTI=https://downloads.loftux.net/public/content/org/alfresco/aos-module/alfresco-vti-bin/1.2.0/alfresco-vti-bin-1.2.0.war
export AOS_SERVER_ROOT=https://downloads.loftux.net/public/content/org/alfresco/alfresco-server-root/6.0/alfresco-server-root-6.0.war
export AOS_AMP=https://downloads.loftux.net/public/content/org/alfresco/aos-module/alfresco-aos-module/1.2.0/alfresco-aos-module-1.2.0.amp

# BART

export BASE_BART_DOWNLOAD=https://raw.githubusercontent.com/toniblyx/alfresco-backup-and-recovery-tool/master/src/

export BART_PROPERTIES=alfresco-bart.properties
export BART_EXECUTE=alfresco-bart.sh

# Color variables
txtund=$(tput sgr 0 1)          # Underline
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgre=${txtbld}$(tput setaf 2) #  red
bldblu=${txtbld}$(tput setaf 4) #  blue
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset
info=${bldwht}*${txtrst}        # Feedback
pass=${bldblu}*${txtrst}
warn=${bldred}*${txtrst}
ques=${bldblu}?${txtrst}

echoblue () {
  echo "${bldblu}$1${txtrst}"
}
echored () {
  echo "${bldred}$1${txtrst}"
}
echogreen () {
  echo "${bldgre}$1${txtrst}"
}

# Check Weather Alfrescoinstall folder exist or not
cd /tmp
if [ -d "alfrescoinstall" ]; then
	rm -rf alfrescoinstall
fi
mkdir alfrescoinstall
cd ./alfrescoinstall

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echogreen "Alfresco CentOS installer by Amine YC."
#echogreen "Please read the documentation at"
#echogreen "https://github.com/amineyc/AlfrescoCentOSInstaller."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo

# Show few Messages

echo
echored "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Installing Alfresco Community edition from Alfresco Software"
echored "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Checking for the availability of the URLs inside script..."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Preparing for install. Updating the YUM package index files..."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
sudo yum $YUMVERBOSITY update &&
echo "checking updates done"

# Installaing dependancy

if [ "`which curl`" = "" ]; then
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "You need to install curl. Curl is used for downloading components to install."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
sudo yum $YUMVERBOSITY install curl;
fi

if [ "`which wget`" = "" ]; then
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "You need to install wget. Wget is used for downloading components to install."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
sudo yum $YUMVERBOSITY install wget;
fi

# Checking URLs

URLERROR=0

for REMOTE in $TOMCAT_DOWNLOAD $JDBCPOSTGRESURL/$JDBCPOSTGRES $JDBCMYSQLURL/$JDBCMYSQL \
        $LIBREOFFICE $ALFREPOWAR $ALFSHAREWAR $ALFSHARESERVICES $GOOGLEDOCSREPO \
        $GOOGLEDOCSSHARE $ASS_DOWNLOAD $AOS_VTI $AOS_SERVER_ROOT

do
        wget --spider $REMOTE --no-check-certificate >& /dev/null
        if [ $? != 0 ]
        then
                echored "In alfinstall.sh, please fix this URL: $REMOTE"
                URLERROR=1
        fi
done

if [ $URLERROR = 1 ]
then
    echo
    echored "Please fix the above errors and rerun."
    echo
    exit
fi

# Adding Alfresco User

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "You need to add a system user that runs the tomcat Alfresco instance."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Add alfresco system user${ques} [y/n] " -i "$DEFAULTYESNO" addalfresco
if [ "$addalfresco" = "y" ]; then
  sudo adduser -M -s /sbin/nologin $ALF_USER
  echo
  echogreen "Finished adding alfresco user"
  echo
else
  echo "Skipping adding alfresco user"
  echo
fi

# Add Local

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "You need to set the locale to use when running tomcat Alfresco instance."
echo "This has an effect on date formats for transformations and support for"
echo "international characters."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Enter the default locale to use: " -i "$LOCALESUPPORT" LOCALESUPPORT
#install locale to support that locale date formats in open office transformations
sudo localectl set-locale LANG=$LOCALESUPPORT
echo
echogreen "Finished updating locale"
echo

# Installaing TOMCAT

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Tomcat is the application server that runs Alfresco."
echo "You will also get the option to install jdbc lib for Postgresql or MySql/MariaDB."
echo "Install the jdbc lib for the database you intend to use."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install Tomcat${ques} [y/n] " -i "$DEFAULTYESNO" installtomcat

if [ "$installtomcat" = "y" ]; then
  echogreen "Installing Tomcat"
  echo "Downloading tomcat..."
  curl -# -L -O $TOMCAT_DOWNLOAD
  # Make sure install dir exists, including logs dir
  sudo mkdir -p $ALF_HOME/logs
  echo "Extracting..."
  tar xf "$(find . -type f -name "apache-tomcat*")"
  sudo mv "$(find . -type d -name "apache-tomcat*")" $CATALINA_HOME
  # Remove apps not needed
  sudo rm -rf $CATALINA_HOME/webapps/*
  # Create Tomcat conf folder
  sudo mkdir -p $CATALINA_HOME/conf/Catalina/localhost
  # Get Alfresco config
  echo "Downloading tomcat configuration files..."

  sudo curl -# -o $CATALINA_HOME/conf/server.xml $BASE_DOWNLOAD/tomcat/server.xml
  sudo curl -# -o $CATALINA_HOME/conf/catalina.properties $BASE_DOWNLOAD/tomcat/catalina.properties
  sudo curl -# -o $CATALINA_HOME/conf/tomcat-users.xml $BASE_DOWNLOAD/tomcat/tomcat-users.xml
  sudo curl -# -o $CATALINA_HOME/conf/context.xml $BASE_DOWNLOAD/tomcat/context.xml
  if [ "$ISON1604" = "y" ]; then
    sudo curl -# -o /etc/systemd/system/alfresco.service $BASE_DOWNLOAD/tomcat/alfresco.service
    sudo curl -# -o $ALF_HOME/alfresco-service.sh $BASE_DOWNLOAD/scripts/alfresco-service.sh
    sudo chmod 755 $ALF_HOME/alfresco-service.sh
    sudo sed -i "s/@@LOCALESUPPORT@@/$LOCALESUPPORT/g" $ALF_HOME/alfresco-service.sh
    # Enable the service
    sudo systemctl enable alfresco.service
    sudo systemctl daemon-reload
  fi

  # Create /shared
  sudo mkdir -p $CATALINA_HOME/shared/classes/alfresco/extension
  sudo mkdir -p $CATALINA_HOME/shared/classes/alfresco/web-extension
  sudo mkdir -p $CATALINA_HOME/shared/lib
  # Add endorsed dir
  sudo mkdir -p $CATALINA_HOME/endorsed

  echo
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo "You need to add the dns name, port and protocol for your server(s)."
  echo "It is important that this is is a resolvable server name."
  echo "This information will be added to default configuration files."
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  read -e -p "Please enter the public host name for Share server (fully qualified domain name)${ques} [`hostname`] " -i "`hostname`" SHARE_HOSTNAME
  read -e -p "Please enter the protocol to use for public Share server (http or https)${ques} [http] " -i "http" SHARE_PROTOCOL
  SHARE_PORT=80
  if [ "${SHARE_PROTOCOL,,}" = "https" ]; then
    SHARE_PORT=443
  fi
  read -e -p "Please enter the host name for Alfresco Repository server (fully qualified domain name) as shown to users${ques} [$SHARE_HOSTNAME] " -i "$SHARE_HOSTNAME" REPO_HOSTNAME
  read -e -p "Please enter the host name for Alfresco Repository server that Share will use to talk to repository${ques} [localhost] " -i "localhost" SHARE_TO_REPO_HOSTNAME

  # Add default alfresco-global.propertis
  ALFRESCO_GLOBAL_PROPERTIES=/tmp/alfrescoinstall/alfresco-global.properties
  sudo curl -# -o $ALFRESCO_GLOBAL_PROPERTIES $BASE_DOWNLOAD/tomcat/alfresco-global.properties
  sed -i "s/@@ALFRESCO_SHARE_SERVER@@/$SHARE_HOSTNAME/g" $ALFRESCO_GLOBAL_PROPERTIES
  sed -i "s/@@ALFRESCO_SHARE_SERVER_PORT@@/$SHARE_PORT/g" $ALFRESCO_GLOBAL_PROPERTIES
  sed -i "s/@@ALFRESCO_SHARE_SERVER_PROTOCOL@@/$SHARE_PROTOCOL/g" $ALFRESCO_GLOBAL_PROPERTIES
  sed -i "s/@@ALFRESCO_REPO_SERVER@@/$REPO_HOSTNAME/g" $ALFRESCO_GLOBAL_PROPERTIES
  sudo mv $ALFRESCO_GLOBAL_PROPERTIES $CATALINA_HOME/shared/classes/

  read -e -p "Install Share config file (recommended)${ques} [y/n] " -i "$DEFAULTYESNO" installshareconfig
  if [ "$installshareconfig" = "y" ]; then
    SHARE_CONFIG_CUSTOM=/tmp/alfrescoinstall/share-config-custom.xml
    sudo curl -# -o $SHARE_CONFIG_CUSTOM $BASE_DOWNLOAD/tomcat/share-config-custom.xml
    sed -i "s/@@ALFRESCO_SHARE_SERVER@@/$SHARE_HOSTNAME/g" $SHARE_CONFIG_CUSTOM
    sed -i "s/@@SHARE_TO_REPO_SERVER@@/$SHARE_TO_REPO_HOSTNAME/g" $SHARE_CONFIG_CUSTOM
    sudo mv $SHARE_CONFIG_CUSTOM $CATALINA_HOME/shared/classes/alfresco/web-extension/
  fi

  echo
  read -e -p "Install Postgres JDBC Connector${ques} [y/n] " -i "$DEFAULTYESNO" installpg
  if [ "$installpg" = "y" ]; then
	curl -# -O $JDBCPOSTGRESURL/$JDBCPOSTGRES
	sudo mv $JDBCPOSTGRES $CATALINA_HOME/lib
  fi
  echo
  read -e -p "Install Mysql JDBC Connector${ques} [y/n] " -i "$DEFAULTYESNO" installmy
  if [ "$installmy" = "y" ]; then
    cd /tmp/alfrescoinstall
	curl -# -L -O $JDBCMYSQLURL/$JDBCMYSQL
	tar xf $JDBCMYSQL
	cd "$(find . -type d -name "mysql-connector*")"
	sudo mv mysql-connector*.jar $CATALINA_HOME/lib
  fi
  sudo chown -R $ALF_USER:$ALF_GROUP $ALF_HOME
  echo
  echogreen "Finished installing Tomcat"
  echo
else
  echo "Skipping install of Tomcat"
  echo
fi

# Installing NGINX

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Nginx can be used as frontend to Tomcat."
echo "This installation will add config default proxying to Alfresco tomcat."
echo "The config file also have sample config for ssl."
echo "You can run Alfresco fine without installing nginx."
echo "If you prefer to use Apache, install that manually. Or you can use iptables"
echo "forwarding, sample script in $ALF_HOME/scripts/iptables.sh"
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install nginx${ques} [y/n] " -i "$DEFAULTYESNO" installnginx
if [ "$installnginx" = "y" ]; then
  echoblue "Installing nginx. Fetching packages..."
  echo
  sudo wget $BASE_DOWNLOAD/nginx/nginx.repo
  sudo mv nginx.repo /etc/yum.repo.d/nginx.repo
  sudo yum $YUMVERBOSITY update && sudo yum $YUMVERBOSITY install nginx
  sudo systemctl enable nginx
  sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
  sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.sample
  sudo curl -# -o /etc/nginx/nginx.conf $BASE_DOWNLOAD/nginx/nginx.conf
  sudo curl -# -o /etc/nginx/conf.d/alfresco.conf $BASE_DOWNLOAD/nginx/alfresco.conf
  sudo curl -# -o /etc/nginx/conf.d/alfresco.conf.ssl $BASE_DOWNLOAD/nginx/alfresco.conf.ssl
  sudo curl -# -o /etc/nginx/conf.d/basic-settings.conf $BASE_DOWNLOAD/nginx/basic-settings.conf
  sudo mkdir -p /var/cache/nginx/alfresco
  # Make the ssl dir as this is what is used in sample config
  sudo mkdir -p /etc/nginx/ssl
  sudo mkdir -p $ALF_HOME/www
  if [ ! -f "$ALF_HOME/www/maintenance.html" ]; then
    echo "Downloading maintenance html page..."
    sudo curl -# -o $ALF_HOME/www/maintenance.html $BASE_DOWNLOAD/nginx/maintenance.html
  fi
  sudo chown -R www-data:root /var/cache/nginx/alfresco
  sudo chown -R www-data:root $ALF_HOME/www
  ## Reload config file
  sudo systemctl start nginx

  echo
  echogreen "Finished installing nginx"
  echo
else
  echo "Skipping install of nginx"
fi

# Installaing Java JDK 1.8
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Install Java JDK."
echo "This will install Oracle Java 8 version of Java. If you prefer OpenJDK"
echo "you need to download and install that manually."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install Oracle Java 8${ques} [y/n] " -i "$DEFAULTYESNO" installjdk
if [ "$installjdk" = "y" ]; then
  echoblue "Installing Oracle Java 8. Fetching packages..."
  sudo yum $YUMVERBOSITY install java-1.8.0-openjdk-devel
  echo
  echogreen "Finished installing Oracle Java 8"
  echo
else
  echo "Skipping install of Oracle Java 8"
  echored "IMPORTANT: You need to install other JDK and adjust paths for the install to be complete"
  echo
fi

#Installing Libreoffice

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Install LibreOffice 5.2.1.2."
echo "This will download and install the latest LibreOffice from libreoffice.org"
echo "Newer version of Libreoffice has better document filters, and produce better"
echo "transformations. If you prefer to use Ubuntu standard packages you can skip"
echo "this install."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install LibreOffice${ques} [y/n] " -i "$DEFAULTYESNO" installibreoffice
if [ "$installibreoffice" = "y" ]; then

  cd /tmp/alfrescoinstall
  curl -# -L -O $LIBREOFFICE
  tar xf LibreOffice*.tar.gz
  cd "$(find . -type d -name "LibreOffice*")"
  cd RPMS
  rm -f *gnome-integration*.rpm &&\
  rm -f *kde-integration*.rpm &&\
  rm -f *freedesktop-menus*.rpm &&\
  sudo yum localinstall *.rpm
  echo
  echoblue "Installing some support fonts for better transformations."
  # libxinerama1 libglu1-mesa needed to get LibreOffice 4.4 to work. Add the libraries that Alfresco mention in documentatinas required.

  ###1604 fonts-droid not available, use fonts-noto instead
  sudo yum $YUMVERBOSITY install google-noto-sans-fonts fontconfig cups-libs libSM libICE libXrender libXext libGLU cairo mesa-libGL-devel
  echo
  echogreen "Finished installing LibreOffice"
  echo
else
  echo
  echo "Skipping install of LibreOffice"
  echored "If you install LibreOffice/OpenOffice separetely, remember to update alfresco-global.properties"
  echored "Also run: sudo yum install google-noto-sans-fonts fontconfig cups-libs libSM libICE libXrender libXext libGLU cairo mesa-libGL-devel"
  echo
fi

# Install ImageMagik

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Install ImageMagick."
echo "This will ImageMagick from Centos Package."
echo "It is recommended that you install ImageMagick."
echo "If you prefer some other way of installing ImageMagick, skip this step."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install ImageMagick${ques} [y/n] " -i "$DEFAULTYESNO" installimagemagick
if [ "$installimagemagick" = "y" ]; then

  echoblue "Installing ImageMagick. Fetching packages..."
  sudo yum $YUMVERBOSITY install gcc php-devel php-pear
  sudo yum $YUMVERBOSITY install ImageMagick ImageMagick-devel
  echo
  echogreen "Finished installing ImageMagick"
  echo
else
  echo
  echo "Skipping install of ImageMagick"
  echored "Remember to install ImageMagick later. It is needed for thumbnail transformations."
  echo
fi

#Extras
echo
echoblue "Adding basic support files. Always installed if not present."
echo
# Always add the addons dir and scripts
  sudo mkdir -p $ALF_HOME/addons/war
  sudo mkdir -p $ALF_HOME/addons/share
  sudo mkdir -p $ALF_HOME/addons/alfresco
  if [ ! -f "$ALF_HOME/addons/apply.sh" ]; then
    echo "Downloading apply.sh script..."
    sudo curl -# -o $ALF_HOME/addons/apply.sh $BASE_DOWNLOAD/scripts/apply.sh
    sudo chmod u+x $ALF_HOME/addons/apply.sh
  fi
  if [ ! -f "$ALF_HOME/addons/alfresco-mmt.jar" ]; then
    sudo curl -# -o $ALF_HOME/addons/alfresco-mmt.jar $ALFMMTJAR
  fi

  # Add the jar modules dir
  sudo mkdir -p $ALF_HOME/modules/platform
  sudo mkdir -p $ALF_HOME/modules/share

  sudo mkdir -p $ALF_HOME/bin
  if [ ! -f "$ALF_HOME/bin/alfresco-pdf-renderer" ]; then
    echo "Downloading Alfresco PDF Renderer binary (alfresco-pdf-renderer)..."
    sudo curl -# -o $TMP_INSTALL/alfresco-pdf-renderer.tgz $ALFRESCO_PDF_RENDERER
    sudo tar -xf $TMP_INSTALL/alfresco-pdf-renderer.tgz -C $TMP_INSTALL
    sudo mv $TMP_INSTALL/alfresco-pdf-renderer $ALF_HOME/bin/
  fi

  sudo mkdir -p $ALF_HOME/scripts
  if [ ! -f "$ALF_HOME/scripts/mariadb.sh" ]; then
    echo "Downloading mariadb.sh install and setup script..."
    sudo curl -# -o $ALF_HOME/scripts/mariadb.sh $BASE_DOWNLOAD/scripts/mariadb.sh
  fi
  if [ ! -f "$ALF_HOME/scripts/postgresql.sh" ]; then
    echo "Downloading postgresql.sh install and setup script..."
    sudo curl -# -o $ALF_HOME/scripts/postgresql.sh $BASE_DOWNLOAD/scripts/postgresql.sh
  fi

  if [ ! -f "$ALF_HOME/scripts/mysql.sh" ]; then
    echo "Downloading mysql.sh install and setup script..."
    sudo curl -# -o $ALF_HOME/scripts/mysql.sh $BASE_DOWNLOAD/scripts/mysql.sh
  fi

  if [ ! -f "$ALF_HOME/scripts/limitconvert.sh" ]; then
    echo "Downloading limitconvert.sh script..."
    sudo curl -# -o $ALF_HOME/scripts/limitconvert.sh $BASE_DOWNLOAD/scripts/limitconvert.sh
  fi
  if [ ! -f "$ALF_HOME/scripts/createssl.sh" ]; then
    echo "Downloading createssl.sh script..."
    sudo curl -# -o $ALF_HOME/scripts/createssl.sh $BASE_DOWNLOAD/scripts/createssl.sh
  fi
  if [ ! -f "$ALF_HOME/scripts/libreoffice.sh" ]; then
    echo "Downloading libreoffice.sh script..."
    sudo curl -# -o $ALF_HOME/scripts/libreoffice.sh $BASE_DOWNLOAD/scripts/libreoffice.sh
    sudo sed -i "s/@@LOCALESUPPORT@@/$LOCALESUPPORT/g" $ALF_HOME/scripts/libreoffice.sh
  fi
  if [ ! -f "$ALF_HOME/scripts/iptables.sh" ]; then
    echo "Downloading iptables.sh script..."
    sudo curl -# -o $ALF_HOME/scripts/iptables.sh $BASE_DOWNLOAD/scripts/iptables.sh
  fi
  if [ ! -f "$ALF_HOME/scripts/alfresco-iptables.conf" ]; then
    echo "Downloading alfresco-iptables.conf upstart script..."
    sudo curl -# -o $ALF_HOME/scripts/alfresco-iptables.conf $BASE_DOWNLOAD/scripts/alfresco-iptables.conf
  fi
  if [ ! -f "$ALF_HOME/scripts/ams.sh" ]; then
    echo "Downloading maintenance shutdown script..."
    sudo curl -# -o $ALF_HOME/scripts/ams.sh $BASE_DOWNLOAD/scripts/ams.sh
  fi
  sudo chmod 755 $ALF_HOME/scripts/*.sh

  # Keystore
  sudo mkdir -p $ALF_DATA_HOME/keystore
  # Only check for precesence of one file, assume all the rest exists as well if so.
  if [ ! -f " $ALF_DATA_HOME/keystore/ssl.keystore" ]; then
    echo "Downloading keystore files..."
    sudo curl -# -o $ALF_DATA_HOME/keystore/browser.p12 $KEYSTOREBASE/browser.p12
    sudo curl -# -o $ALF_DATA_HOME/keystore/generate_keystores.sh $KEYSTOREBASE/generate_keystores.sh
    sudo curl -# -o $ALF_DATA_HOME/keystore/keystore $KEYSTOREBASE/keystore
    sudo curl -# -o $ALF_DATA_HOME/keystore/keystore-passwords.properties $KEYSTOREBASE/keystore-passwords.properties
    sudo curl -# -o $ALF_DATA_HOME/keystore/ssl-keystore-passwords.properties $KEYSTOREBASE/ssl-keystore-passwords.properties
    sudo curl -# -o $ALF_DATA_HOME/keystore/ssl-truststore-passwords.properties $KEYSTOREBASE/ssl-truststore-passwords.properties
    sudo curl -# -o $ALF_DATA_HOME/keystore/ssl.keystore $KEYSTOREBASE/ssl.keystore
    sudo curl -# -o $ALF_DATA_HOME/keystore/ssl.truststore $KEYSTOREBASE/ssl.truststore
  fi

# Install Alfresco War files and Modules Packages

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Install Alfresco war files."
echo "Download war files and optional addons."
echo "If you have already downloaded your war files you can skip this step and add "
echo "them manually."
echo
echo "If you use separate Alfresco and Share server, only install the needed for each"
echo "server. Alfresco Repository will need Share Services if you use Share."
echo
echo "This install place downloaded files in the $ALF_HOME/addons and then use the"
echo "apply.sh script to add them to tomcat/webapps. Se this script for more info."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Add Alfresco Repository war file${ques} [y/n] " -i "$DEFAULTYESNO" installwar
if [ "$installwar" = "y" ]; then

  echogreen "Downloading alfresco war file..."
  sudo curl -# -o $ALF_HOME/addons/war/alfresco.war $ALFREPOWAR
  echo

  # Add default alfresco and share modules classloader config files
  sudo curl -# -o $CATALINA_HOME/conf/Catalina/localhost/alfresco.xml $BASE_DOWNLOAD/tomcat/alfresco.xml

  echogreen "Finished adding Alfresco Repository war file"
  echo
else
  echo
  echo "Skipping adding Alfresco Repository war file and addons"
  echo
fi

read -e -p "Add Share Client war file${ques} [y/n] " -i "$DEFAULTYESNO" installsharewar
if [ "$installsharewar" = "y" ]; then

  echogreen "Downloading Share war file..."
  sudo curl -# -o $ALF_HOME/addons/war/share.war $ALFSHAREWAR

  # Add default alfresco and share modules classloader config files
  sudo curl -# -o $CATALINA_HOME/conf/Catalina/localhost/share.xml $BASE_DOWNLOAD/tomcat/share.xml

  echo
  echogreen "Finished adding Share war file"
  echo
else
  echo
  echo "Skipping adding Alfresco Share war file"
  echo
fi

if [ "$installwar" = "y" ] || [ "$installsharewar" = "y" ]; then
cd /tmp/alfrescoinstall

if [ "$installwar" = "y" ]; then
    echored "You must install Share Services if you intend to use Share Client."
    read -e -p "Add Share Services plugin${ques} [y/n] " -i "$DEFAULTYESNO" installshareservices
    if [ "$installshareservices" = "y" ]; then
      echo "Downloading Share Services addon..."
      curl -# -O $ALFSHARESERVICES
      sudo mv alfresco-share-services*.amp $ALF_HOME/addons/alfresco/
    fi
fi

read -e -p "Add Google docs integration${ques} [y/n] " -i "$DEFAULTYESNO" installgoogledocs
if [ "$installgoogledocs" = "y" ]; then
  echo "Downloading Google docs addon..."
  if [ "$installwar" = "y" ]; then
    curl -# -O $GOOGLEDOCSREPO
    sudo mv alfresco-googledocs-repo*.amp $ALF_HOME/addons/alfresco/
  fi
  if [ "$installsharewar" = "y" ]; then
    curl -# -O $GOOGLEDOCSSHARE
    sudo mv alfresco-googledocs-share* $ALF_HOME/addons/share/
  fi
fi
fi
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Install Alfresco Office Services (Sharepoint protocol emulation)."
echo "This allows you to open and save Microsoft Office documents online."
echored "This module is not Open Source (Alfresco proprietary)."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install Alfresco Office Services integration${ques} [y/n] " -i "$DEFAULTYESNO" installssharepoint
if [ "$installssharepoint" = "y" ]; then
    echogreen "Installing Alfresco Offices Services bundle..."
    echogreen "Downloading Alfresco Office Services amp file"
    # Sub shell to keep the file name
    (cd $ALF_HOME/addons/alfresco;sudo curl -# -O $AOS_AMP)
    echogreen "Downloading _vti_bin.war into tomcat/webapps"
    sudo curl -# -o $ALF_HOME/tomcat/webapps/_vti_bin.war $AOS_VTI
    echogreen "Downloading ROOT.war into tomcat/webapps"
    sudo curl -# -o $ALF_HOME/tomcat/webapps/ROOT.war $AOS_SERVER_ROOT
fi

# Install of war and addons complete, apply them to war file
if [ "$installwar" = "y" ] || [ "$installsharewar" = "y" ] || [ "$installssharepoint" = "y" ]; then
    # Check if Java is installed before trying to apply
    if type -p java; then
        _java=java
    elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
        _java="$JAVA_HOME/bin/java"
        echored "No JDK installed. When you have installed JDK, run "
        echored "$ALF_HOME/addons/apply.sh all"
        echored "to install addons with Alfresco or Share."
    fi
    if [[ "$_java" ]]; then
        sudo $ALF_HOME/addons/apply.sh all
    fi
fi

# Install Solr

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Install Solr6 Alfresco Search Services indexing engine."
echo "You can run Solr6 on a separate server, unless you plan to do that you should"
echo "install the Solr6 indexing engine on the same server as your repository server."
echored "Alfresco Serch Services will be installed without SSL!"
echored "Configure firewall to block port 8983 or install ssl, see"
echored "https://docs.alfresco.com/community/tasks/solr6-install.html"
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install Solr6 indexing engine${ques} [y/n] " -i "$DEFAULTYESNO" installsolr
if [ "$installsolr" = "y" ]; then

  # Make sure we have unzip available
  sudo yum $YUMVERBOSITY install unzip

  echogreen "Downloading Solr6 file..."
  sudo curl -# -o $ALF_HOME/solr6.zip $ASS_DOWNLOAD
  echogreen "Expanding Solr6 file..."
  cd $ALF_HOME
  sudo unzip -q solr6.zip
  sudo mv alfresco-search-services solr6
  sudo rm solr6.zip

  echogreen "Downloading Solr6 scripts and settings file..."
  sudo curl -# -o /etc/systemd/system/alfresco-search.service $BASE_DOWNLOAD/search/alfresco-search.service
  sudo curl -# -o $ALF_HOME/solr6/solrhome/conf/shared.properties $BASE_DOWNLOAD/search/shared.properties
  sudo curl -# -o $ALF_HOME/solr6/solr.in.sh $BASE_DOWNLOAD/search/solr.in.sh
  sudo chmod u+x $ALF_HOME/solr6/solr.in.sh
# Enable the service
    sudo systemctl enable alfresco-search.service
    sudo systemctl daemon-reload

  echo
  echogreen "Finished installing Solr6 engine."
  echored "Verify your setting in alfresco-global.properties."
  echo "Set property value index.subsystem.name=solr6"
  echo
else
  echo
  echo "Skipping installing Solr6."
  echo "You can always install Solr6 at a later time."
  echo
fi

# No BART At this moment

# Finally, set the permissions
sudo chown -R $ALF_USER:$ALF_GROUP $ALF_HOME
if [ -d "$ALF_HOME/www" ]; then
   sudo chown -R www-data:root $ALF_HOME/www
fi
