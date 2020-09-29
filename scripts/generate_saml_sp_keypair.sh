#!/bin/bash

source ../nextcloud.env

# Install required packages
sudo apt-get install libsaml9 libcurl3 libxmltooling7 libshibsp-plugins shibboleth-sp2-utils

# Generate the keypair
sudo shib-keygen -f -u _shibd -h ${VIRTUAL_HOST} -y 3 -e https://${VIRTUAL_HOST}/shibboleth

# Display the key
sudo cat /etc/shibboleth/sp-key.pem

# Display the certificate
sudo cat /etc/shibboleth/sp-cert.pem