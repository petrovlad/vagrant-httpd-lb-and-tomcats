#!/bin/bash

echo "tomcat${1} provision start!1!11!!11!!"

# install java
echo "Updating yum..."
yum update > /dev/null > /dev/null
echo "Installing java..."
yum install -y java > /dev/null

# install wget
echo "Installing wget..."
yum install -y wget > /dev/null

TOMCAT_DIR="/usr/local/tomcat"
TOMCAT_NAME="apache-tomcat-8.5.66"
mkdir --parents "$TOMCAT_DIR"
echo "Downloading $TOMCAT_NAME..."
wget -q "https://mirror.datacenter.by/pub/apache.org/tomcat/tomcat-8/v8.5.66/bin/${TOMCAT_NAME}.tar.gz" -O "${TOMCAT_DIR}/${TOMCAT_NAME}.tar.gz"
echo "Extracting ${TOMCAT_NAME}.tar.gz..."
tar xzf "${TOMCAT_DIR}/${TOMCAT_NAME}.tar.gz" -C "${TOMCAT_DIR}/"

# deploying
echo "Deploying clusterjsp..."
cp /vagrant/clusterjsp.war "${TOMCAT_DIR}/${TOMCAT_NAME}/webapps/"
echo "Starting tomcat-server${1}..."
"${TOMCAT_DIR}/${TOMCAT_NAME}"/bin/startup.sh
