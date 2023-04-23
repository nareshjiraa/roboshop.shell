script=$(realpath "0$")
script_path=$(dirname "$script")
source ${scipt_path}/common.sh
yum install nginx -y
rm /etc/nginx/default.d/roboshop.conf
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf
systemctl enable nginx
systemctl start nginx
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
systemctl restart nginx
