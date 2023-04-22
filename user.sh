echo -e "\e[32m<<<<<setup node js repo>>>>\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[32m<<<<<install nodejs>>>>\e[0m"
yum install nodejs -y
echo -e "\e[32m<<<<<add roboshop user>>>>\e[0m"
useradd roboshop
echo -e "\e[32m<<<<<remove directory>>>>\e[0m"
rm -rf /app
echo -e "\e[32m<<<<<create directory>>>>\e[0m"
mkdir /app
echo -e "\e[32m<<<<<unzip in app directory>>>>\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
echo -e "\e[32m<<<<<download dependencies>>>>\e[0m"
cd /app
npm install
echo -e "\e[32m<<<<<Setup SystemD User Service>>>>\e[0m"
cp /home/centos/user.service /etc/systemd/system/user.service
echo -e "\e[32m<<<<<Load the service>>>>\e[0m"
systemctl daemon-reload
echo -e "\e[32m<<<<<Start service>>>>\e[0m"
systemctl enable user
systemctl start user
echo -e "\e[32m<<<<< setup MongoDB repo>>>>\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[32m<<<<< install mongodb-client>>>>\e[0m"
yum install mongodb-org-shell -y
echo -e "\e[32m<<<<< Load Schemat>>>>\e[0m"
mongo --host mongodb-dev.mahadevops.online </app/schema/user.js