#!/bin/sh
set -eu

su -p www-data -s /bin/bash -c /gss_config.sh &
/entrypoint.sh "$@"
