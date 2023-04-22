echo -e "\e[33m<<<<<setup nodejs repo>>\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[33m<<<<<install nodejs >>\e[0m"
yum install nodejs -y
echo -e "\e[33m<<<<<add roboshop user >>\e[0m"
useradd roboshop
echo -e "\e[33m<<<<<remove app directory >>\e[0m"
rm -rf /app
echo -e "\e[33m<<<<<create app directory >>\e[0m"
mkdir /app
echo -e "\e[33m<<<<<download app code >>\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip
echo -e "\e[33m<<<<<download dependencies>>\e[0m"
cd /app
npm install
echo -e "\e[33m<<<<<setup suystemd service>>\e[0m"
cp /home/centos/roboshop.shell/cart.service /etc/systemd/system/cart.service
echo -e "\e[33m<<<<<load service>>\e[0m"
systemctl daemon-reload
echo -e "\e[33m<<<<<start service>>\e[0m"
systemctl enable cart
systemctl start cart