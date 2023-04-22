echo -e "\e[31m<<<<<<<install redis repo>>>\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
echo -e "\e[31m<<<<<<<Enable Redis>>>\e[0m"
dnf module enable redis:remi-6.2 -y
echo -e "\e[31m<<<<<<<install redis >>>\e[0m"
yum install redis -y
echo -e "\e[31m<<<<<<<replace 127.0.0.1>>>\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0 |' /etc/redis/redis.conf
echo -e "\e[31m<<<<<<<restart>>>\e[0m"
systemctl enable redis
systemctl restart redis