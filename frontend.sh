script=$(realpath "0$")
script_path=$(dirname "$script")
source ${scipt_path}/common.sh

func_print_head "Install Nginx"
yum install nginx -y &>>$log_file
func_stat_check $?

func_print_head "copy roboshop config file"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_stat_check $?

func_print_head "clean old app content"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_stat_check $?

func_print_head "download app content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_stat_check $?

func_print_head "extracting app content"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
func_stat_check $?

func_print_head "start nginx"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
func_stat_check $?





