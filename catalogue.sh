script=$(realpath "0$")
script_path=$(dirname "$script")
source ${script_path}/common.sh
component=catalogue
func_nodejs
echo -e "\e[35m>>>copy mongo repo file\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[33m>>>install mongod client\e[0m"
yum install mongodb-org-shell -y
mongo --host mongodb-dev.mahadevops.online </app/schema/catalogue.js