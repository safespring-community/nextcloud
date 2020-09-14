#!/bin/bash
set -eu

echo "Redeploying Nextcloud Server"

docker rm -f nextcloud_app_1 nextcloud_cron_1 nextcloud_db_1 nextcloud_redis_1 nextcloud_proxy_1 || true
docker volume prune -f

source nextcloud.env
echo "Storage type: "${STORAGE_TYPE}

if [ ${STORAGE_TYPE} == 's3' ]
then
  source s3.env
  s3cmd rm s3://${S3_BUCKET} --recursive --force
fi

docker-compose build --no-cache
docker-compose up -d

echo "Nextcloud Server Redeployed"

