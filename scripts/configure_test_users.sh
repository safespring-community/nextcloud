#!/bin/bash

source scripts.env

docker exec -u www-data -it nextcloud_app_1 /bin/bash -c "\
	php occ group:add --display-name 'Group 1' -- group1 && \
	php occ group:add --display-name 'Group 2' -- group2 && \
	export OC_PASS=${TEST_USER_PASSWORD} && \
	php occ user:add --password-from-env --display-name 'User1 (Group 1)' --group group1 -- user1 && \
	php occ user:add --password-from-env --display-name 'User2 (Group 2)' --group group2 -- user2 && \
	php occ user:add --password-from-env --display-name 'User3 (Group 1 & 2)' --group group1 --group group2 -- user3 \
"

