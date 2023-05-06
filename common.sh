app_user=roboshop
func_print_head() {
  echo -e "\e[35m>>>>>>$1<<<<<<<\e[0m"
}

func_schema_setup(){
  if [ "$func_schema_setup" == "mongo" ];then
    func_print_head "copy MongoDB repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    func_print_head "install MongoDb client"
    yum install mongodb-org-shell -y

    func_print_head "load schema"
    mongo --host mongodb-dev.mahadevops.online </app/schema/$(component).js
    fi

  if [ "$func_schema_setup" == "mysql" ];then
    func_print_head "installmysqlclient"
      yum install mysql -y

      func_print_head "Load Schema"
      mysql -h mysql-dev.mahadevops.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
      fi

}

func_app_prereq(){
    func_print_head "add user"
    useradd roboshop

    func_print_head "remove app directory"
    rm -rf /app

    func_print_head "create app directory"
    mkdir /app

    func_print_head "download app code"
    curl -L -o /tmp/$(component).zip https://roboshop-artifacts.s3.amazonaws.com/$(component).zip
    cd /app
    unzip /tmp/$(component).zip
}

func_systemd_setup(){
    func_print_head "Setup SystemD $(component) Service"
    cp ${script_path}/$(component).service /etc/systemd/system/$(component).service

   func_print_head "load service"
    systemctl daemon-reload

    func_print_head "Start the service"
    systemctl enable $(component)
    systemctl start $(component)
    systemctl restart $(component)
}

func_nodejs() {
  func_print_head "setup nodejs repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_print_head "install nodejs"
  yum install nodejs -y

  func_app_prereq

  func_print_head "download dependencies"
  cd /app
  npm install

 func_schema_setup
 func_systemd_setup


}

func_java() {
  func_print_head "install maven"
  yum install maven -y

 func_print_head "download dependencies"
  cd /app
  mvn clean package
  mv target/$(component)-1.0.jar $(component).jar

  func_schema_setup
  func_systemd_setup


}