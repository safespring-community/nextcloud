#!/bin/bash

echo "Installing and configuring Global Site Selector"

while ! php /var/www/html/occ status | grep -q 'installed: true' 
do
  echo "Waiting for the Nextcloud installation to complete..."
  sleep 5
done

echo "Installing GSS app"
while ! php /var/www/html/occ app:enable globalsiteselector | grep -q 'globalsiteselector already enabled\|globalsiteselector enabled'
do
  echo "GSS app installation failed, retry in 5 seconds"
  sleep 5
done
echo "GSS app installed"

echo "Configuring GSS app"
php /var/www/html/occ config:system:set gs.enabled --value=true
php /var/www/html/occ config:system:set gs.federation --value=${GS_FEDERATION}
php /var/www/html/occ config:system:set gss.jwt.key --value=${GSS_JWT_KEY}
php /var/www/html/occ config:system:set gss.mode --value=${GSS_MODE}
php /var/www/html/occ config:system:set lookup_server --value=${LOOKUP_SERVER}

if [ ${GSS_MODE} == 'master' ]
then
  php /var/www/html/occ config:system:set gss.master.admin 0 --value=${GSS_MASTER_ADMIN}
elif [ ${GSS_MODE} == 'slave' ]
then
  php /var/www/html/occ config:system:set gss.master.url --value=${GSS_MASTER_URL}
fi

echo "GSS app configured"

