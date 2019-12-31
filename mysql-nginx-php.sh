#!/bin/bash
#mysql
yum -y install https://repo.percona.com/yum/percona-release-latest.noarch.rpm
yum -y install Percona-XtraDB-Cluster-57
yum -y update
service mysql start
pass=$(grep 'temporary password' /var/log/mysqld.log | awk '{print($11)}')
mysql -uroot -p$pass -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Vega123312##';" --connect-expired-password
#nginx
touch /etc/yum.repos.d/nginx.repo
basearch='$basearch'
cat > /etc/yum.repos.d/nginx.repo <<EOF
[nginx]
name=nginx repo
baseurl=https://nginx.org/packages/mainline/centos/7/$basearch/
gpgcheck=0
enabled=1
EOF
yum -y update
yum -y install nginx
systemctl start nginx
#php-fpm
yum -y install epel-release && \
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
yum -y install yum-utils && \
yum-config-manager --enable remi-php72 && \
yum -y update && \
yum -y install php && \
yum -y install php-fpm php-gd php-json php-mbstring php-mysqlnd php-xml php-xmlrpc php-opcache
systemctl start php-fpm
#mysql
yum -y localinstall https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
yum -y install mysql-community-server
grep 'A temporary password' /var/log/mysqld.log |tail -1
