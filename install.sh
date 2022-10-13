#!/bin/sh
# Install NGINX with PHP 7.4 and PHP-FPM
# Hi Performance Web Server with Lets Encryt, with Cache, with Compress

read -N 999999 -t 0.001
iname=$(ip addr show | awk '/inet.*brd/{print $NF; exit}')
echo $iname


# Set Name Server for the System
###########################################################################
# For Amazon CentOS 7
echo "PEERDNS=no" >> /etc/sysconfig/network-scripts/ifcfg-$iname
mkdir -p /etc/NetworkManager/conf.d/
echo -e  '[main]\ndns=none' > /etc/NetworkManager/conf.d/disable-resolve.conf-managing.conf
echo -e "nameserver 9.9.9.9\nnameserver 1.1.1.1\nnameserver 8.8.8.8" > /etc/resolv.conf
#---------------------------------------------------------------------------------------------


# Get all input and execute one by one.
###########################################################################

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils epel-release
yum -y install centos-release-scl.noarch
yum install -y yum-utils
yum-config-manager --enable remi-php74

# Some Variable Set Here
###########################################################################
read  -p "Enter Your FQDN Hostname : " HNAME
read  -p "If you Need SWAP Enter Amount of GB (0 for none) : " SWAPGB

# Set Hostname
###########################################################################

hostnamectl $HNAME
sysctl kernel.hostname=$HNAME
sysctl -w kernel.hostname=$HNAME

# Install Required Software
###########################################################################

yum install -y yum wget curl  dos2unix net-tools crontabs dos2unix httpd-tools
yum install -y libgcrypt libgcrypt-devel gcc-c++ openvpn easy-rsa iptables-services net-tools wget nano zip unzip yum htop bmon vnstat nano zip unzip curl
yum install -y openssl-pkcs11 openssl11-static openssl098e openssl11-devel openssl openssl11  openssl-devel openssl11-libs openssl-perl openssl-static openssl-libs



# Change Server Time Zone
###########################################################################

yum install ntpdate -y
rm -f /etc/localtime
echo "ZONE=Asia/Dhaka"  > /etc/sysconfig/clock
timedatectl set-timezone Asia/Dhaka
ntpdate pool.ntp.org
ntpdate pool.ntp.org
hwclock -wu
hwclock -wu
service ntpdate restart
chkconfig ntpdate on
service ntpdate restart



# Disable Security
###########################################################################

setenforce 0
echo -e "SELINUX=disable\nSELINUXTYPE=targeted" > /etc/sysconfig/selinux


# Disable All Kind of Firewall
###########################################################################
systemctl stop firewalld
systemctl mask firewalld
systemctl disable firewalld

# Set IPTables Default
###########################################################################

# Flush All and Set New Rules
iptables -F
iptables -t nat -F
iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -I OUTPUT -o eth0 -d 10.0.0.0/8 -j DROP
iptables -I OUTPUT -o eth0 -d 172.16.0.0/12 -j DROP
iptables -I OUTPUT -o eth0 -d 192.168.0.0/16 -j DROP
iptables -t nat -A POSTROUTING -o $iname -j MASQUERADE
iptables-save > /etc/sysconfig/iptables


# Install System Network Usage Tools
vnstat --create -i $iname
systemctl restart vnstat
systemctl enable vnstat

echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

systemctl restart iptables
systemctl enable iptables
systemctl enable iptables.service




# Set System Parameter
###########################################################################
wget -O /etc/sysctl.conf  https://raw.githubusercontent.com/abdsmd/Hi-Performance-LEMP-on-Centos-7/main/sysctl.conf
wget -O /etc/security/limits.conf https://github.com/abdsmd/Hi-Performance-LEMP-on-Centos-7/raw/main/limits.conf

dos2unix /etc/sysctl.conf
sysctl -p




# Update System
###########################################################################

yum update -y
yum install epel-release -y
yum update -y

# Install NGINX
###########################################################################

yum update -y
yum install -y nginx php php-mysqlnd php-fpm php-opcache \
   php-pecl-apcu php-cli php-pear \
   php-pdo php-pgsql php-pecl-mongodb \
   php-pecl-redis php-pecl-memcache \
   php-gd php-mbstring php-mcrypt php-xml \
   php-mysql php-soap php-xmlrpc php-json  \
   php-zlib php-mysqli php-curl php-openssl \
   ImageMagick

# Remove if there is any file
rm -rf /usr/share/nginx/html/*

wget -O /etc/nginx/nginx.conf https://github.com/abdsmd/Hi-Performance-LEMP-on-Centos-7/raw/main/nginx.conf
dos2unix /etc/nginx/nginx.conf
pkill -9 nginx
pkill -9 php-fpm
systemctl restart nginx
systemctl restart php-fpm


# Set System Open File Limit of NGINX 
###########################################################################

echo "nginx   soft    nofile  65536" >> /etc/security/limits.d/nginx.conf
echo "nginx   hard    nofile  65536" >> /etc/security/limits.d/nginx.conf



# If you need PhantomJS
#yum install -y glibc fontconfig freetype freetype-devel fontconfig-devel wget bzip2
#wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
#tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/
#ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin
#phantomjs --version


# Install MySQL 5.7
###########################################################################
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum localinstall https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
yum install mysql-community-server
systemctl restart mysqld
systemctl enable mysqld
grep 'A temporary password' /var/log/mysqld.log | tail -1
mysql_secure_installation


# Configure PHP-FPM
###############################################################
# Download and replace the configuration from this repository file
wget -O /etc/php-fpm.conf https://raw.githubusercontent.com/abdsmd/Hi-Performance-LEMP-on-Centos-7/main/php-fpm.conf
wget -O /etc/php-fpm.d/www.conf https://raw.githubusercontent.com/abdsmd/Hi-Performance-LEMP-on-Centos-7/main/www.conf


# Install Lets Encrypt $HNAME is the hostname or you can set the hostname directly
yum install -y certbot python2-certbot-nginx
# certbot certonly --nginx --agree-tos --preferred-challenges http --register-unsafely-without-email -d $HNAME

# Make lets encrypt renew certificate automatically
cat <<EOF>/etc/cron.daily/letsencrypt-renew
#!/bin/sh
if certbot renew > /var/log/letsencrypt/renew.log 2>&1 ; then
   nginx -s reload
fi
exit
EOF

chmod 777 /etc/cron.daily/letsencrypt-renew

# Install redis 
###############################################################
yum install redis -y
wget -O /etc/redis.conf https://github.com/abdsmd/Hi-Performance-LEMP-on-Centos-7/raw/main/redis.conf
wget -O /etc/systemd/system/redis.service.d/limit.conf https://github.com/abdsmd/Hi-Performance-LEMP-on-Centos-7/raw/main/redis-limit.conf
systemctl restart redis
redis-cli ping
# You will see PONG if its working
# systemctl daemon-reload



## Install Supervisor
#############################################################################

yum install -y supervisor
wget -O /etc/supervisord.conf https://github.com/abdsmd/Hi-Performance-LEMP-on-Centos-7/raw/main/supervisord.conf
systemctl restart supervisord

# Check the Superviosr Tasks
supervisorctl status all
supervisorctl start all

# Install supervisorctl task
# Add a new supervisor task , here I add laravel queue:work which always need to keep running

wget -O /etc/supervisord.d/queue-work.ini https://github.com/abdsmd/Supervisor-Install/raw/master/supervisor-task.ini
supervisorctl reread
supervisorctl update
supervisorctl reload
supervisorctl restart all
supervisorctl status all

# You can check supervisor task and status in web, 
# Browse with your http://IP_ADDRESS:9001
# username = supervisor
# password = abcd1234
# U can edit this credential on supervisord.conf file



# Create SWAP Ram File, Here I am trying to Make 4GB of SWAP, 
# If you want you can increase the size according to your need
###################################################################################
if [[ $SWAPGB > 0 ]]; then
   dd if=/dev/zero of=/swapfile count=4096 bs=1MiB
   chmod 600 /swapfile
   mkswap /swapfile
   setenforce 0
   swapon -f /swapfile
   swapon -s
   free -m
   # Make the changes permanent, It will remain after restart the system
   echo "/swapfile     swap     swap     sw     0     0" >> /etc/fstab
   # Make some change to use SWAP when the system need it, make more for use this file more
   echo "50" > /proc/sys/vm/vfs_cache_pressure
fi


# Composer Install version Latest Version
######################################################################################
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
HASH="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm -rf /usr/bin/composer
ln -s /usr/local/bin/composer /usr/bin/composer


# Configure SSHD
######################################################################################
wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/abdsmd/Hi-Performance-LEMP-on-Centos-7/main/sshd_config
dos2unix /etc/ssh/sshd_config
systemctl restart sshd

######################################################################################
######################################################################################
# Make the enable after the system restart


ulimit -c unlimited
ulimit -d unlimited
ulimit -f unlimited
ulimit -i unlimited
ulimit -n 999999
ulimit -q unlimited
ulimit -u unlimited
ulimit -v unlimited
ulimit -x unlimited
ulimit -s 32388608
ulimit -l unlimited

wget -O /watchdog.sh https://github.com/abdsmd/Hi-Performance-LEMP-on-Centos-7/raw/main/watchdog.sh
dos2unix /watchdog.sh
chmod 777 /watchdog.sh
wget https://github.com/abdsmd/Hi-Performance-LEMP-on-Centos-7/raw/main/rc.local -O ->> /etc/rc.local
dos2unix /etc/rc.local




# Start and Enable on System Startup

systemctl start nginx
systemctl enable nginx
systemctl start php-fpm
systemctl enable php-fpm
systemctl restart crond
systemctl enable crond
systemctl restart redis
systemctl enable redis
systemctl restart supervisord
systemctl enable supervisord
supervisorctl reread
supervisorctl update
supervisorctl restart all

chgrp nginx /var/lib/php/session
chmod 777 -R /var/lib/php/session
chmod 777 -R /tmp

chown nginx:nginx /usr/share/nginx/html/ -R

#-------------------------------------------------------------------------------------
## For Laravel Project
#chmod 777 -R /usr/share/nginx/html/storage 
#chmod 777 -R /usr/share/nginx/html/bootstrap
#find /path/to/your/laravel-directory -type f -exec chmod 644 {} \;
#find /path/to/your/laravel-directory -type d -exec chmod 755 {} \;
#chown -R nginx:nginx /path/to/your/laravel-directory
#find /path/to/your/laravel-directory -type f -exec chmod 664 {} \;
#find /path/to/your/laravel-directory -type d -exec chmod 775 {} \;
#cd /path/to/your/laravel-directory
#chgrp -R nginx storage bootstrap/cache
#chmod -R ug+rwx storage bootstrap/cache
#-------------------------------------------------------------------------------------

# To install virtual host or multiple domain check my other tutorial,
# How to install wordpress check my other tutorial

