echo -e "\e[31m<<<Install GoLang>>\e[0m"
yum install golang -y
echo -e "\e[31m<<<user add>>\e[0m"
useradd roboshop
echo -e "\e[31m<<<create app directory>>\e[0m"
mkdir /app
echo -e "\e[31m<<<download app code>>\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip
echo -e "\e[31m<<<download dependencies>>\e[0m"
cd /app
go mod init dispatch
go get
go build
echo -e "\e[31m<<<setup systemd service>>\e[0m"
cp /home/centos/roboshop.shell/dispatch.service /etc/systemd/system/dispatch.service
echo -e "\e[31m<<<load service>>\e[0m"
systemctl daemon-reload
echo -e "\e[31m<<<start service>>\e[0m"
systemctl enable dispatch
systemctl start dispatch