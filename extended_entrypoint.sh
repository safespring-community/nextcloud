#!/bin/sh
set -eu

echo "Configuring S3 as primary storage"
envsubst '$S3_BUCKET $S3_KEY $S3_SECRET $S3_HOSTNAME $S3_REGION' < /var/www/html/config/s3.config.template > /var/www/html/config/s3.config.php
echo "S3 storage configured"

su -p www-data -s /bin/bash -c /gss_config.sh &
/entrypoint.sh "$@"
