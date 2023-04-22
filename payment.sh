echo -e "\e[32m<<<install python 3.6>>\e[0m"
yum install python36 gcc python3-devel -y
echo -e "\e[32m<<add user>>\e[0m"
useradd roboshop
echo -e "\e[32m<<add app directory>>\e[0m"
mkdir /app
echo -e "\e[32m<<Download the application code>>\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip
echo -e "\e[32m<<Download dependencies>>\e[0m"
cd /app
pip3.6 install -r requirements.txt
echo -e "\e[32m<<setup sysd service>>\e[0m"
cp /home/centos/roboshop.shell/payment.service /etc/systemd/system/payment.service
echo -e "\e[32m<<load service>>\e[0m"
systemctl daemon-reload
echo -e "\e[32m<<start service>>\e[0m"
systemctl enable payment
systemctl start payment
