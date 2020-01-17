sudo yum install /usr/bin/luarocks -y
sudo yum-config-manager --add-repo https://openresty.org/yum/cn/centos/OpenResty.repo
sudo yum install openresty -y
luarocks install lapis
ln -s /usr/lib64/lua    /usr/local/lib/lua
ln -s /usr/share/lua   /usr/local/share/lua
yum install mysql-devel -y
ln -s /usr/lib64/mysql/libmysqlclient.so /usr/lib64/libmysqlclient.so
luarocks install luasql-mysql MYSQL_INCDIR=/usr/include/mysql
lapis migrate
