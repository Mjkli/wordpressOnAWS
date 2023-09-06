#!/bin/bash

# wait for machine to come up
sleep 30

# Mounting EFS target
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport efs-dns:/ /var/www/html/wordpress

# Check if there is files in the efs directory if empty add default wordpress file else continue
if [ -n "$(ls -A /var/www/html/wordpress 2>/dev/null)" ]
then
  echo "config files are here"
else
  curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /var/www/html/wordpress
fi

sudo a2ensite wordpress
sudo a2enmod rewrite
sudo a2dissite 000-default
sudo service apache2 reload