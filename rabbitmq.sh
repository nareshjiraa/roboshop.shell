script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "rabbitmq_appuser_password" ]; then
  echo input rabbitmq appuser pasword missing
  exit
fi
echo -e "\e[36m<<<setup rabbitmq repos>>\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m<<<install erlang>>\e[0m"
yum install erlang -y

echo -e "\e[36m<<<YUM Repos for RabbitMQ.>>\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m<<<Install RabbitMQ server>>\e[0m"
yum install rabbitmq-server -y

echo -e "\e[36m<<<Start RabbitMQ Service>>\e[0m"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

echo -e "\e[36m<<<add user>>\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"