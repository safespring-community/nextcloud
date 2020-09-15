#!/bin/bash
set -eu

POSITIONAL=()
ERASE_S3='0'
PRUNE_VOLUMES='0'
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -e|--erase)
    ERASE_S3='1'
    shift # past argument
    ;;
    -p|--prune)
    PRUNE_VOLUMES='1'
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo "Redeploying Nextcloud Server"

docker rm -f nextcloud_app_1 nextcloud_cron_1 nextcloud_db_1 nextcloud_redis_1 nextcloud_proxy_1 || true

if [ ${PRUNE_VOLUMES} == '1' ]
then
  echo "Pruning docker volumes with label com.docker.compose.project=nextcloud"
  docker volume prune --force --filter label=com.docker.compose.project=nextcloud
fi

if [ ${ERASE_S3} == '1' ]
then
  source s3.env
  echo "Erasing S3 bucket [${OBJECTSTORE_S3_BUCKET}]"
  s3cmd rm s3://${OBJECTSTORE_S3_BUCKET} --recursive --force
fi

source nextcloud.env
export NEXTCLOUD_VERSION
docker-compose build --no-cache

source redis.env # get redis password
export REDIS_HOST_PASSWORD
docker-compose up -d

echo "Nextcloud Server Redeployed"

