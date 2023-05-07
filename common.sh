app_user=roboshop
script=$(realpath "$0")
acript_path=$(dirname "$script")
log_file=/tmp/roboshop.log


func_print_head() {
  echo -e "\e[35m>>>>>>$1<<<<<<<\e[0m"
}

func_stat_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\[32mSUCCCESS\e[0m"
  else
    echo -e "\[31mFAILURE]e[0m"
    echo "refer the log file /tmp/roboshop.log for more info"
    exit 1
  fi
}

func_schema_setup(){
  if [ "$func_schema_setup" == "mongo" ];then
    func_print_head "copy MongoDB repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file

    func_print_head "install MongoDb client"
    yum install mongodb-org-shell -y &>>$log_file

    func_print_head "load schema"
    mongo --host mongodb-dev.mahadevops.online </app/schema/$(component).js &>>$log_file
    fi

  if [ "$func_schema_setup" == "mysql" ];then
    func_print_head "installmysqlclient"
      yum install mysql -y &>>$log_file

      func_print_head "Load Schema"
      mysql -h mysql-dev.mahadevops.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>$log_file
  fi

}

func_app_prereq(){
    func_print_head "add user"
    useradd roboshop &>>$log_file

    func_print_head "remove app directory"
    rm -rf /app &>>$log_file

    func_print_head "create app directory"
    mkdir /app &>>$log_file

    func_print_head "download app code"
    curl -L -o /tmp/$(component).zip https://roboshop-artifacts.s3.amazonaws.com/$(component).zip &>>$log_file
    cd /app &>>$log_file
    unzip /tmp/$(component).zip &>>$log_file
}

func_systemd_setup(){
    func_print_head "Setup SystemD $(component) Service"
    cp ${script_path}/$(component).service /etc/systemd/system/$(component).service &>>$log_file

   func_print_head "load service"
    systemctl daemon-reload &>>$log_file

    func_print_head "Start the service"
    systemctl enable $(component) &>>$log_fil
    systemctl start $(component) &>>$log_file
    systemctl restart $(component) &>>$log_file
}

func_nodejs() {
  func_print_head "setup nodejs repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file

  func_print_head "install nodejs"
  yum install nodejs -y &>>$log_file
  func_stat_check $?


  func_app_prereq

  func_print_head "download dependencies"
  cd /app &>>$log_file
  npm install &>>$log_file
  func_stat_check $?

 func_schema_setup
 func_systemd_setup


}

func_java() {
  func_print_head "install maven"
  yum install maven -y &>>$log_file
  func_stat_check $?

 func_app_prereq

 func_print_head "download dependencies"
  cd /app &>>$log_file
  mvn clean package &>>$log_file
   func_stat_check $?
  mv target/$(component)-1.0.jar $(component).jar &>>$log_file


  func_schema_setup
  func_systemd_setup


}