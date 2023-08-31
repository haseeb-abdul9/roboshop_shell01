echo -e "\e[32m>>>>>>>>Install redis repo<<<<<<<<\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[32m>>>>>>>>Install redis<<<<<<<\e[0m"
yum module enable redis:remi-6.2 -y
yum install redis -y

echo -e "\e[32m>>>>>>>>Change port<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0' /etc/redis.conf

echo -e "\e[32m>>>>>>>>Start Redis<<<<<<<<\e[0m"
systemctl enable redis
systemctl restart redis