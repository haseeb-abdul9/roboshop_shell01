script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo Input rabbitmq_password missing
  exit
fi

print_head "Install Mavenprint_head"
yum install maven -y

print_head "Add application user & Directoryprint_head"
useradd roboshop
rm -rf /app
mkdir /app

print_head "Download & unzip app contentprint_head"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip

print_head "Download Dependenciesprint_head"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

print_head "create service fileprint_head"
cp  /home/centos/Roboshop-shell/shipping.service /etc/systemd/system/shipping.service

print_head "Load serviceprint_head"
systemctl daemon-reload

print_head "Install MySQLprint_head"
yum install mysql -y

print_head "Change MySQl default passwordprint_head"
mysql -h mysql-dev.haseebdevops.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql

print_head "start shippingprint_head"
systemctl enable shipping
systemctl restart shipping
