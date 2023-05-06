script=$(realpath "0$")
script_path=$(dirname "$script")
source ${scipt_path}/common.sh
mysql_root_password=$1

if [ -z "mysql_root_password" ]; then
  echo input mysql root password missing
  exit
fi

echo -e "\e[35m<<<disable mysql 8>>\e[0m"
dnf module disable mysql -y
echo -e "\e[35m<<<setup mysql 5.7>>\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
echo -e "\e[35m<<<install mysql server>>\e[0m"
yum install mysql-community-server -y
echo -e "\e[35m<<<start service>>\e[0m"
systemctl enable mysqld
systemctl start mysqld
echo -e "\e[35m<<<set root passwd>>\e[0m"
mysql_secure_installation --set-root-pass ${mysql_root_password}
echo -e "\e[35m<<<test oot passwd>>\e[0m"
mysql -uroot -pRoboShop@1