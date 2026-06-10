#!/bin/sh
set -e

if [ "$(id -u)" = "0" ] && [ -d /var/lib/mysql ]; then
	find /var/lib/mysql -type d -exec chmod a+rwx {} +
	find /var/lib/mysql -type f -exec chmod a+rw {} +
	find /var/lib/mysql -maxdepth 1 -type f \( -name '*.cnf' -o -name '*.pem' \) -exec chmod a-w,a+r {} +
fi

exec docker-entrypoint.sh "$@"
