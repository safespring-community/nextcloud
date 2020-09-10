#!/bin/bash
set -eu

su -p www-data -s /bin/bash -c /gss_config.sh &
su -p www-data -s /bin/bash -c /mail_config.sh &
/entrypoint.sh "$@"
