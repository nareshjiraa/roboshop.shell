app_user=roboshop
print_head() {
  echo -e "\e[35m>>>>>>$1<<<<<<<\e[0m"
}

schema_setup(){
  if [ "$schema_setup" == "mongo" ];then
    print_head "copy MongoDB repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    print_head "install MongoDb client"
    yum install mongodb-org-shell -y

    print_head "load schema"
    mongo --host mongodb-dev.mahadevops.online </app/schema/catalogue.js
    fi
}

func_nodejs() {
  print_head "setup nodejs repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head "install nodejs"
  yum install nodejs -y

  print_head"add roboshop user"
  useradd ${app_user}

  print_head "remove app directory"
  rm -rf /app

  print_head "create app directory"
  mkdir /app

  print_head "download app code"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  unzip /tmp/${component}.zip

  print_head "download dependencies"
  cd /app
  npm install

  print_head "setup suystemd service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  print_head"load service"
  systemctl daemon-reload

  print_head "start service"
  systemctl enable ${component}
  systemctl start ${component}

  schema_setup
}
