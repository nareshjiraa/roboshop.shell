script=$(realpath "0$")
script_path=$(dirname "$script")
source ${scipt_path}/common.sh
component=user
func_nodejs
echo -e "\e[32m<<<<< setup MongoDB repo>>>>\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[32m<<<<< install mongodb-client>>>>\e[0m"
yum install mongodb-org-shell -y
echo -e "\e[32m<<<<< Load Schemat>>>>\e[0m"
mongo --host mongodb-dev.mahadevops.online </app/schema/user.js