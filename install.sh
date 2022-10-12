#!/bin/sh
# Install NGINX with PHP 7.4 and PHP-FPM
# Hi Performance Web Server with Lets Encryt, No Cache, No Compress


read -N 999999 -t 0.001
yum update -y
yum install epel-release -y
yum update -y
yum install -y libgcrypt libgcrypt-devel gcc-c++ openvpn easy-rsa iptables-services net-tools wget nano zip unzip yum htop bmon vnstat nginx nano zip unzip curl  dos2unix net-tools crontabs
yum install -y yum wget curl  dos2unix net-tools crontabs dos2unix httpd-tools
yum install -y openssl-pkcs11 openssl11-static openssl098e openssl11-devel openssl openssl11  openssl-devel openssl11-libs openssl-perl openssl-static openssl-libs

hostnamectl set-hostname 13-36-180-5.ut360.net
sysctl kernel.hostname
sysctl kernel.hostname=13-36-180-5.ut360.net
sysctl -w kernel.hostname=13-36-180-5.ut360.net

## Server Time Set ##
yum install ntpdate -y
rm -f /etc/localtime
echo "ZONE=Asia/Dhaka"  > /etc/sysconfig/clock
ntpdate pool.ntp.org
ntpdate pool.ntp.org
hwclock -wu
hwclock -wu
service ntpdate restart
chkconfig ntpdate on
date
hwclock
service ntpdate restart

yum install -y ntpdate
timedatectl set-timezone Asia/Dhaka
ntpdate pool.ntp.org
hwclock -wu




echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf
setenforce 0
cat <<EOF >/etc/sysconfig/selinux
SELINUX=disable
SELINUXTYPE=targeted
EOF



systemctl stop firewalld
systemctl mask firewalld
systemctl disable firewalld

systemctl restart crond
systemctl enable crond


## System Parameter and IPTables
###########################################################################
###########################################################################
## System Parameter and IPTables

cat << EOF>/etc/sysctl.conf 
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
kernel.exec-shield = 1
kernel.randomize_va_space = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5
net.ipv4.conf.all.log_martians = 0
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.proxy_arp = 1
net.ipv4.ip_forward = 1
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv6.conf.eth0.disable_ipv6 = 1
EOF

nano /etc/security/limits.d/nginx.conf
nginx   soft    nofile  65536
nginx   hard    nofile  65536

sysctl -p
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

iname=$(ip addr show | awk '/inet.*brd/{print $NF; exit}')
echo $iname

iptables -F
iptables -t nat -F
iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -I OUTPUT -o eth0 -d 10.0.0.0/8 -j DROP
iptables -I OUTPUT -o eth0 -d 172.16.0.0/12 -j DROP
iptables -I OUTPUT -o eth0 -d 192.168.0.0/16 -j DROP
iptables -t nat -A POSTROUTING -o $iname -j MASQUERADE
iptables-save > /etc/sysconfig/iptables

systemctl restart iptables
systemctl enable iptables
systemctl enable iptables.service

vnstat --create -i $iname
systemctl restart vnstat
systemctl enable vnstat

# Install NGINX
yum update -y

yum install nginx -y

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils epel-release
yum -y install centos-release-scl.noarch
yum install -y yum-utils
yum-config-manager --enable remi-php74
yum install -y php php-mysqlnd php-fpm php-opcache php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongodb php-pecl-redis php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml
yum install -y php-mysql php-xml php-mysql php-xml php-soap php-xmlrpc php-mbstring php-json php-gd php-mcrypt
yum install -y php php-zlib php-mysqli php-curl php-json php-cli php-pear php-gd php-openssl php-xml php-mbstring php-fpm ImageMagick

# PhantomJS
yum install -y glibc fontconfig freetype freetype-devel fontconfig-devel wget bzip2
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/
ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin
phantomjs --version

# libmcrypt-dev  php-pear php-fpm  php-mysql php-dev php-redis php-curl nmap 
# Redis server  
# MariaDB or MySQL Nginx Superviso


######################################################
######################################################
# MySQL 5.7 Installation #################################
######################################################
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum localinstall https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
yum install mysql-community-server
systemctl restart mysqld
systemctl enable mysqld
grep 'A temporary password' /var/log/mysqld.log |tail -1
mysql_secure_installation
######################################################
######################################################
yum install composer -y
curl icanhazip.com
systemctl start nginx
systemctl enable nginx
systemctl start php-fpm
systemctl enable php-fpm

chgrp nginx /var/lib/php/session
chmod 777 -R /var/lib/php/session

###############################################################

cat <<EOF>/etc/php-fpm.conf
include=/etc/php-fpm.d/*.conf
[global]
pid = /run/php-fpm/php-fpm.pid
error_log = /var/log/php-fpm/error.log
;syslog.facility = daemon
;syslog.ident = php-fpm
;log_level = notice
;log_limit = 4096
;log_buffering = no

emergency_restart_threshold = 3
emergency_restart_interval = 1
process_control_timeout = 5s

process.max = 0
process.priority = -19
daemonize = yes
rlimit_files = 131072
rlimit_core = unlimited

events.mechanism = epoll
;systemd_interval = 10
EOF


cat <<EOF>/etc/php-fpm.d/www.conf
[www]
user = nginx
group = nginx
listen = 127.0.0.1:9000
; listen = /var/run/php-fpm/php5-fpm.sock

; Set listen(2) backlog.
; Default Value: 511
;listen.backlog = 511

; Set permissions for unix socket, if one is used. In Linux, read/write
; permissions must be set in order to allow connections from a web server.
; Default Values: user and group are set as the running user
;                 mode is set to 0660

listen.owner = nginx
listen.group = nginx
listen.mode = 0660

listen.allowed_clients = 127.0.0.1
pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35
pm.process_idle_timeout = 10s;
pm.max_requests = 100000

slowlog = /var/log/php-fpm/www-slow.log
rlimit_files = 131072
rlimit_core = unlimited
env[HOSTNAME] = $HOSTNAME
;env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp
;php_admin_value[sendmail_path] = /usr/sbin/sendmail -t -i -f www@my.domain.com
;php_flag[display_errors] = off
php_admin_value[error_log] = /var/log/php-fpm/www-error.log
php_admin_flag[log_errors] = on
;php_admin_value[memory_limit] = 128M

php_value[session.save_handler] = files
php_value[session.save_path]    = /var/lib/php/session
php_value[soap.wsdl_cache_dir]  = /var/lib/php/wsdlcache
;php_value[opcache.file_cache]  = /var/lib/php/opcache
EOF

###############################################################
### Now Configure php-fpm and nginx configure
# Install Lets Encrypt
yum install -y certbot python2-certbot-nginx
#certbot certonly --nginx --agree-tos --preferred-challenges http --register-unsafely-without-email -d 13-36-180-5.ut360.net

yum install -y crontabs 
systemctl restart crond
systemctl enable crond

cat << EOF>/etc/cron.daily/letsencrypt-renew
#!/bin/sh
if certbot renew > /var/log/letsencrypt/renew.log 2>&1 ; then
   nginx -s reload
fi
exit
EOF

chmod 777 /etc/cron.daily/letsencrypt-renew
#######################################

## Install redis 
#########################################################
yum install redis -y
systemctl restart redis
systemctl enable redis
redis-cli ping

echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
echo "net.core.somaxconn=1024" >> /etc/sysctl.conf
echo "fs.file-max = 26214400" >> /etc/sysctl.conf


echo "renice -n -20 -u redis" >> /etc/rc.local
echo "renice -n -20 -u nginx" >> /etc/rc.local
echo "renice -n -20 -u mysqld" >> /etc/rc.local

echo "ulimit -c unlimited" >> /etc/rc.local
echo "ulimit -d unlimited" >> /etc/rc.local
echo "ulimit -f unlimited" >> /etc/rc.local
echo "ulimit -i unlimited" >> /etc/rc.local
echo "ulimit -n 999999" >> /etc/rc.local
echo "ulimit -q unlimited" >> /etc/rc.local
echo "ulimit -u unlimited" >> /etc/rc.local
echo "ulimit -v unlimited" >> /etc/rc.local
echo "ulimit -x unlimited" >> /etc/rc.local
echo "ulimit -s 8388608" >> /etc/rc.local
echo "ulimit -l unlimited" >> /etc/rc.local


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

sysctl -p
systemctl restart redis

echo "redis soft nofile 10000000" >> /etc/security/limits.conf
echo "redis hard nofile 10000000" >> /etc/security/limits.conf


cat <<EOF> /etc/systemd/system/redis.service.d/limit.conf
[Service]
LimitNOFILE=65536
EOF

nano /etc/rc.local
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
    echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi

systemctl daemon-reload
systemctl restart redis.service


cat <<EOF>/etc/redis.conf
bind 127.0.0.1
protected-mode yes
port 6379
tcp-backlog 511
timeout 0
tcp-keepalive 300
daemonize yes
supervised auto
pidfile /var/run/redis_6379.pid
loglevel notice
logfile /var/log/redis/redis.log
databases 16000
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error no
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir /var/lib/redis
slave-serve-stale-data yes
slave-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
slave-priority 100
appendonly yes
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
lua-time-limit 5000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes
maxmemory 0
maxmemory-policy allkeys-lru
maxclients 1000000
EOF


systemctl restart redis

## Supervisor
#############################################################################

yum install -y supervisor
cat <<EOF>/etc/supervisord.conf
[unix_http_server]
file=/var/run/supervisor/supervisor.sock   ; (the path to the socket file)
;chmod=0700                 ; sockef file mode (default 0700)
;chown=nobody:nogroup       ; socket file uid:gid owner
;username=user              ; (default is no username (open server))
;password=123               ; (default is no password (open server))

[inet_http_server]
port=*:9001
username=supervisor
password=abcd1234

[supervisorctl]
serverurl=unix:///var/run/supervisor/supervisor.sock ; use a unix:// URL  for a unix socket
serverurl=http://*:9001 ; use an http:// url to specify an inet socket
username=supervisor
password=abcd1234
prompt=supervisorShell
history_file=~/.sc_history  ; use readline history if available

[supervisord]
logfile=/var/log/supervisor/supervisord.log  ; (main log file;default $CWD/supervisord.log)
logfile_maxbytes=50MB
logfile_backups=10
loglevel=info               ; (log level;default info; others: debug,warn,trace)
pidfile=/var/run/supervisord.pid
nodaemon=false
minfds=1024
minprocs=200
;umask=022
user=root
identifier=supervisor
directory=/tmp
nocleanup=true
childlogdir=/tmp
environment=KEY=value
strip_ansi=false

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface



; The below sample group section shows all possible group values,
; create one or more 'real' group: sections to create "heterogeneous"
; process groups.

;[group:thegroupname]
;programs=progname1,progname2  ; each refers to 'x' in [program:x] definitions
;priority=999                  ; the relative start priority (default 999)

[include]
files = supervisord.d/*.ini
EOF

systemctl restart supervisord
systemctl enable supervisord
supervisorctl status all
supervisorctl start all
# Install supervisorctl task
supervisorctl reread
supervisorctl update
supervisorctl reload
supervisorctl restart all
supervisorctl status all

# Time Save

# SWAP Ram File
###################################################################################
dd if=/dev/zero of=/swapfile count=4096 bs=1MiB
chmod 600 /swapfile
mkswap /swapfile
setenforce 0
swapon -f /swapfile
swapon -s
free -m
echo "/swapfile     swap     swap     sw     0     0" >> /etc/fstab
echo "50" > /proc/sys/vm/vfs_cache_pressure

######################################################################################
######################################################################################
# NGINX domain install

######################################################################################
######################################################################################
######################################################################################
######################################################################################

rm -rf /usr/share/nginx/html/*
cat <<EOF>/etc/nginx/nginx.conf
user nginx;
worker_processes auto;
worker_rlimit_nofile 100000;
pid /var/run/nginx.pid;
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 4000;
    use epoll;
    multi_accept on;
}

http {
    limit_conn_zone $binary_remote_addr zone=conn_limit_per_ip:10m;
    limit_req_zone $binary_remote_addr zone=req_limit_per_ip:10m rate=5r/s;
    open_file_cache max=200000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;
    underscores_in_headers on;
    add_header X-Cache-Status $upstream_cache_status;
    log_format  main_ext  '$remote_addr - $remote_user [$time_local] "$request" '
                     '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for" '
                      '"$host" sn="$server_name" '
                      'rt=$request_time '
                      'ua="$upstream_addr" us="$upstream_status" '
                      'ut="$upstream_response_time" ul="$upstream_response_length" '
                      'cs=$upstream_cache_status' ;

    #access_log off;
    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    types_hash_max_size 2048;
    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;
    gzip off;
    gzip_min_length 10240;
    gzip_comp_level 1;
    gzip_vary on;
    gzip_disable msie6;
    gzip_proxied expired no-cache no-store private auth;
    gzip_types image/jpeg image/bmp image/svg+xml text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript image/x-icon;

    #security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src * data: 'unsafe-eval' 'unsafe-inline'" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    reset_timedout_connection on;
    client_body_timeout 10;
    send_timeout 2;
    keepalive_timeout 30;
    keepalive_requests 100000;
    include /etc/nginx/conf.d/*.conf;
    proxy_cache_path /tmp/cacheapi levels=1:2 keys_zone=microcacheapi:100m max_size=1g inactive=1d use_temp_path=off;

    server {
        limit_conn conn_limit_per_ip 10;
        limit_req zone=req_limit_per_ip burst=10 nodelay;
        listen       80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;
        index index.php index.html index.htm;

        error_log  /var/log/nginx/error.log crit;
        access_log  /var/log/nginx/access.log  main_ext;

        include /etc/nginx/default.d/*.conf;

        location / {
            try_files $uri $uri/ /index.php?$query_string ;
        }

        location ~* \.(jpg|jpeg|png|gif|ico)$ {
            expires 30d;
        }
        location ~* \.(css|js)$ {
            expires 7d;
        }

        location ~ /\. {
            deny  all;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }

        location ~ \.php$ {
            try_files $uri =404;
            fastcgi_pass unix:/var/run/php-fpm/php5-fpm.sock;
            #fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }

        client_body_buffer_size  128k;
        client_header_buffer_size 3m;
        large_client_header_buffers 4 256k;
        client_body_timeout   3m;
        client_header_timeout 3m;
    }

}
EOF

######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################
# Composer Install version 2
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
HASH="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm -rf /usr/bin/composer
ln -s /usr/local/bin/composer /usr/bin/composer


upload the project in /usr/share/nginx/html


cd /usr/share/nginx/html
composer install

chown nginx:nginx /usr/share/nginx/html/ -R
chmod 777 -R /usr/share/nginx/html/storage 
chmod 777 -R /usr/share/nginx/html/bootstrap
systemctl restart nginx
mkdir -p /usr/share/nginx/html/storage/app/service/api
mkdir -p /usr/share/nginx/html/storage/app/service/check
mkdir -p /usr/share/nginx/html/storage/app/service/website
chmod 777 -R /usr/share/nginx/html/storage
chown nginx:nginx -R /usr/share/nginx/html


######################################################################################

[program:uptime-worker]
process_name=%(program_name)s_%(process_num)02d
command=/usr/bin/php /usr/share/nginx/html/artisan queue:work --timeout=60  --tries=3
#user=root
autostart=true
autorestart=true
numprocs=1
redirect_stderr=true
stdout_logfile=/usr/share/nginx/html/storage/logs/uptime_monitor.log


supervisorctl reread
supervisorctl update
supervisorctl restart all

######################################################################################

# in UT360 Main Server RUN 
php artisan checksConfig:setup
php artisan websiteConfig:setup
php artisan apiConfig:setup
php artisan channelConfig:setup



## crontab

0 */2 * * * /usr/bin/php /var/www/html/monitor_station/artisan check:blacklist


crontab -e

01 02,14 * * * /etc/cron.daily/letsencrypt-renew
* * * * * pidof nginx >/dev/null && sleep 1 || echo "NGINX NOT running" && systemctl restart nginx
* * * * * pidof mysqld >/dev/null && sleep 1 || echo "MYSQLD NOT running" && systemctl restart mysqld
* * * * * pidof php-fpm >/dev/null && sleep 1 || echo "PHP-FPM NOT running" && systemctl restart php-fpm
#######################################


put nameserver for google for all the servers


sudo chown -R www-data:www-data /path/to/your/laravel-directory
sudo usermod -a -G www-data ubuntu
sudo find /path/to/your/laravel-directory -type f -exec chmod 644 {} \;
sudo find /path/to/your/laravel-directory -type d -exec chmod 755 {} \;
sudo chown -R my-user:www-data /path/to/your/laravel-directory
sudo find /path/to/your/laravel-directory -type f -exec chmod 664 {} \;
sudo find /path/to/your/laravel-directory -type d -exec chmod 775 {} \;
sudo chgrp -R www-data storage bootstrap/cache
sudo chmod -R ug+rwx storage bootstrap/cache




you can set PEERDNS=no in the relevant /etc/syscofig/network-scripts/ifcfg-* file which will stop dhclient from changing /etc/resolv.conf.

Once you've done that you can configure /etc/resolv.conf however you like.


delete 
etc/ssh/lightsail_instance_ca.pub.


influxdb server

   1  sudo apt update -y
    2  sudo curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
    3  sudo echo "deb https://repos.influxdata.com/ubuntu bionic stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
    4  sudo apt install influxdb -y
    5  sudo systemctl start influxdb
    6  sudo systemctl status influxdb
    7  nano /etc/influxdb/influxdb.conf
    8  curl -XPOST "http://localhost:8086/query" --data-urlencode "q=CREATE USER superadmin WITH PASSWORD 'superadminabcd1234' WITH ALL PRIVILEGES"
    9  influx -username 'admin' -password 'monitox360abcd'
   10  sudo apt install influxdb-client
   11  sudo systemctl status influxdb
   12  influx
   13  influx -username 'admin' -password 'monitox360abcd'
   14  influx -username 'influxadmin' -password 'superadminabcd1234'
   15  influx user create -u influxuser -p influxuserabcd1234 -o klouder
   16  influx user create -n influxuser -p influxuserabcd1234 -o klouder
   17  influx
   18  nano /etc/influxdb/influxdb.conf
   19  sudo sytectl restart influxdb
   20  sudo systectl restart influxdb
   21  sudo systemctl restart influxdb
   22  influx -username 'influxdbuser' -password 'monitorabcd1234'
   23  passwd
   24  systemctl restart influx
   25  systemctl restart influxdb
   26  tail -f /var/log/syslog
   27  htop
   28  history

