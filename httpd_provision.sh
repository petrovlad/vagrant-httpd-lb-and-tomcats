#!/bin/bash

# parameters:
# $1 - ip address 1st tomcat server
# $2 - ip address 2nd tomcat server

echo "httpd provision start!!1!11!"

# install httpd
echo "Updating yum..."
# there is too mush "/dev/null", but i decided to print only small info messages + stderr
yum update > /dev/null
echo "Installing httpd..."
yum install -y httpd > /dev/null

# List of required modules:
# mod_proxy.so
# mod_proxy_http.so
# mod_proxy_balancer.so
# mod_lbmethod_byrequests.so
# we don't need to load modules manually, because they all are already loaded in 00-proxy.conf

# create proxy.conf
echo "Creating /etc/httpd/conf.d/proxy.conf..."
cat <<EOT >> /etc/httpd/conf.d/proxy.conf
<Proxy balancer://proxy-balancer>
    BalancerMember http://$1:8080
    BalancerMember http://$2:8080
    ProxySet lbmethod=byrequests
</Proxy>

ProxyPass /clusterjsp balancer://proxy-balancer/clusterjsp
ProxyPassReverse /clusterjsp http://$1:8080/clusterjsp
ProxyPassReverse /clusterjsp http://$2:8080/clusterjsp

EOT

# editing servername
sed -i 's/#ServerName.*/ServerName httpd-server.com:80/' /etc/httpd/conf/httpd.conf 

# restart server
echo "Starting httpd server..."
systemctl start httpd
