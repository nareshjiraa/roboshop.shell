script=$(realpath "0$")
script_path=$(dirname "$script")
source ${scipt_path}/common.sh
echo -e "\e[36m<<install maven>>\e[0m"
yum install maven -y
echo -e "\e[36m<<add user>>\e[0m"
useradd roboshop
echo -e "\e[36m<<remove app directory>>\e[0m"
rm -rf /app
echo -e "\e[36m<<create app directory>>\e[0m"
mkdir /app
echo -e "\e[36m<<<download app code>>\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip
echo -e "\e[36m<<download dependencies>>\e[0m"
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar
echo -e "\e[36m<<<Setup SystemD Shipping Service>>\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service
echo -e "\e[36m<<load service>>\e[0m"
systemctl daemon-reload
echo -e "\e[36m<<<Start the service>>\e[0m"
systemctl enable shipping
systemctl start shipping
echo -e "\e[36m<<installmysqlclient>>\e[0m"
yum install mysql -y
echo -e "\e[36m<<Load Schema>>\e[0m"
mysql -h mysql-dev.mahadevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
systemctl restart shipping