#!/bin/bash
set -eu

echo "Storage type: "${STORAGE_TYPE}

if [ ${STORAGE_TYPE} == 's3' ]
then
  echo "Configuring S3 as primary storage"
  envsubst '$S3_BUCKET $S3_KEY $S3_SECRET $S3_HOSTNAME $S3_REGION' < /var/www/html/config/s3.config.template > /var/www/html/config/s3.config.php
  echo "S3 storage configured"
fi

su -p www-data -s /bin/bash -c /gss_config.sh &
/entrypoint.sh "$@"
