echo -e "\e[35m<<<disable mysql 8>>\e[0m"
dnf module disable mysql -y
echo -e "\e[35m<<<setup mysql 5.7>>\e[0m"
cp /home/centos/roboshop.shell/mysql.repo /etc/yum.repos.d/mysql.repo
echo -e "\e[35m<<<install mysql server>>\e[0m"
yum install mysql-community-server -y
echo -e "\e[35m<<<start service>>\e[0m"
systemctl enable mysqld
systemctl start mysqld
echo -e "\e[35m<<<set root passwd>>\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1
echo -e "\e[35m<<<test oot passwd>>\e[0m"
mysql -uroot -pRoboShop@1