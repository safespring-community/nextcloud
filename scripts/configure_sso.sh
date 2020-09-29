#!/bin/bash

docker cp saml.json nextcloud_app_1:/var/www/html/saml.json
docker cp mappingfile.json nextcloud_app_1:/var/www/html/mappingfile.json

docker exec -u www-data -it nextcloud_app_1 /bin/bash -c "\
	php occ app:enable user_saml && \
	php occ config:import saml.json && \
	php occ config:system:set gss.user.discovery.module --value "\\\\OCA\\\\GlobalSiteSelector\\\\UserDiscoveryModules\\\\ManualUserMapping" && \
	php occ config:system:set gss.discovery.manual.mapping.file --value "\/var\/www\/html\/mappingfile.json" && \
    php occ config:system:set gss.discovery.manual.mapping.parameter --value "urn:oid:1.3.6.1.4.1.5923.1.1.1.6" \
"
