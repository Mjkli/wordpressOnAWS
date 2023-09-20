#!/bin/bash

# wait for machine to come up
sleep 30

# Mounting EFS target
sudo mkdir /var/www/html/wordpress
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns}:/ /var/www/html/wordpress

# Check if there is files in the efs directory if empty add default wordpress file else continue
if [ -n "$(ls -A /var/www/html/wordpress 2>/dev/null)" ]
then
  echo "config files are here"
else
  sudo curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
  sudo tar -xf  /tmp/wordpress.tar.gz -C /var/www/html/wordpress
  sudo sed -i "s/database_name_here/${db_name}/g" /var/www/html/wp-config.php
  sudo sed -i "s/username_here/${db_user}/g" /var/www/html/wp-config.php
  sudo sed -i "s/password_here/replace_me/g" /var/www/html/wp-config.php
  sudo sed -i "s/localhost/${rds_server}/g" /var/www/html/wp-config.php
  sudo cp /var/www/html/wp-config.php /var/www/html/wordpress/wordpress
  sudo unzip /var/www/html/w3-total-cache.zip -d /var/www/html/wordpress/wordpress/plugins/w3-total-cache
  sudo mkdir /var/www/html/wordpress/wordpress/wp-content/upgrade
  sudo chown -R www-data /var/www/html/wordpress/wordpress/
fi

sudo a2ensite wordpress
sudo a2enmod rewrite
sudo a2dissite 000-default
sudo a2enmod ssl
sudo service apache2 reload