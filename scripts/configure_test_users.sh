#!/bin/bash

source scripts.env

CURRENT_NEXTCLOUD_VERSION=$(docker exec -u www-data nextcloud_app_1 php occ --version | cut -d' ' -f2 | cut -d '.' -f1)

if [ ${CURRENT_NEXTCLOUD_VERSION} == '17' ]
then
  echo "Nextcloud version 17"
  docker exec -u www-data -it nextcloud_app_1 /bin/bash -c "\
	php occ group:add group1 && \
	php occ group:add group2 && \
	export OC_PASS=${TEST_USER_PASSWORD} && \
	php occ user:add --password-from-env --display-name 'User1@${HOSTNAME} (Group 1)' --group group1 -- user1_${HOSTNAME} && \
	php occ user:add --password-from-env --display-name 'User2@${HOSTNAME} (Group 2)' --group group2 -- user2_${HOSTNAME} && \
	php occ user:add --password-from-env --display-name 'User3@${HOSTNAME} (Group 1 & 2)' --group group1 --group group2 -- user3_${HOSTNAME} \
"
elif [ ${CURRENT_NEXTCLOUD_VERSION} == '18' ]
then
  echo "Nextcloud version 18\n"
  docker exec -u www-data -it nextcloud_app_1 /bin/bash -c "\
	php occ group:add --display-name 'Group 1' -- group1 && \
	php occ group:add --display-name 'Group 2' -- group2 && \
	export OC_PASS=${TEST_USER_PASSWORD} && \
	php occ user:add --password-from-env --display-name 'User1 (Group 1)' --group group1 -- user1 && \
	php occ user:add --password-from-env --display-name 'User2 (Group 2)' --group group2 -- user2 && \
	php occ user:add --password-from-env --display-name 'User3 (Group 1 & 2)' --group group1 --group group2 -- user3 \
"
elif [ ${CURRENT_NEXTCLOUD_VERSION} == '19' ]
then
  echo "Nextcloud version 19\n"
  docker exec -u www-data -it nextcloud_app_1 /bin/bash -c "\
	php occ group:add --display-name 'Group 1' -- group1 && \
	php occ group:add --display-name 'Group 2' -- group2 && \
	export OC_PASS=${TEST_USER_PASSWORD} && \
	php occ user:add --password-from-env --display-name 'User1 (Group 1)' --group group1 -- user1 && \
	php occ user:add --password-from-env --display-name 'User2 (Group 2)' --group group2 -- user2 && \
	php occ user:add --password-from-env --display-name 'User3 (Group 1 & 2)' --group group1 --group group2 -- user3 \
"
fi
