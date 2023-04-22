echo -e "\e[31m>>>>Setup Node JS Repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[31m>>>Install Node JS\e[0m"
yum install nodejs -y
echo -e "\e[31m>>>madd roboshop user\e[0m"
useradd roboshop
echo -e "\e[31m>>>>create directory\e[0m"
rm -rf /app
mkdir /app
echo -e "\e[31m>>>>download app content\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
echo -e "\e[31m>>>unzip app content\e[0m"
unzip /tmp/catalogue.zip
cd /app
echo -e "\e[31m>>>install dependencies\e[0m"
npm install
echo -e "\e[31m>>>copy catalouge Systemd file \e[0m"
cp /home/centos/roboshop.shell/catalogue.service /etc/systemd/system/catalogue.service
sed -i -e 's|<MONGODB-SERVER-IPADDRESS>|mongodb-dev.mahadevops.online|' /etc/systemd/system/catalogue.service
echo -e "\e[31m>>restart\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
echo -e "\e[35m>>>copy mongo repo file\e[0m"
cp /home/centos/roboshop.shell/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[33m>>>install mongod client\e[0m"
yum install mongodb-org-shell -y
mongo --host mongodb-dev.mahadevops.online </app/schema/catalogue.js