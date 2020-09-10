#!/bin/bash

echo "Script to configure mail"

while ! php /var/www/html/occ status | grep -q 'installed: true' 
do
  echo "Waiting for the Nextcloud installation to complete..."
  sleep 5
done

echo "Configuring mail"
#php /var/www/html/occ config:system:set mail_smtpmode --value=${MAIL_SMTPMODE}
#php /var/www/html/occ config:system:set mail_sendmailmode --value=${MAIL_SENDMAILMODE}

php /var/www/html/occ user:setting ${NEXTCLOUD_ADMIN_USER} settings email "${NEXTCLOUD_ADMIN_EMAIL}"

echo "Mail configured"

