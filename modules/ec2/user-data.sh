#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1
sudo systemctl start nginx
sudo systemctl enable nginx
sudo yum install https://repo.mysql.com/mysql80-community-release-el7-10.noarch.rpm -y
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
sudo yum-config-manager --disable mysql57-community
sudo yum-config-manager --enable mysql80-community
sudo yum clean all
sudo yum makecache
sudo yum install mysql-community-client -y
sudo export LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN=1
sudo curl -O https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
EOF
            



