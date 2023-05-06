script=$(realpath "0$")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=catalogue
func_nodejs
schema_setup=mongo

echo -e "\e[35m>>>copy mongo repo file\e[0m"

echo -e "\e[33m>>>install mongod client\e[0m"

