#!/bin/bash

source ../s3.env
export OBJECTSTORE_S3_HOST OBJECTSTORE_S3_KEY OBJECTSTORE_S3_SECRET OBJECTSTORE_S3_REGION
envsubst < external_storage_definition.json_template > external_storage_definition.json
docker cp external_storage_definition.json nextcloud_app_1:/var/www/html/external_storage_definition.json

docker exec -u www-data -it nextcloud_app_1 /bin/bash -c "\
	php occ app:enable files_external && \
	php occ files_external:import external_storage_definition.json \
"

