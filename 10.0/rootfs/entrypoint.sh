#!/bin/bash
set -e

# Replace {{ ENV }} vars
_envtpl() {
  mv "$1" "$1.tpl" # envtpl requires files to have .tpl extension
  envtpl "$1.tpl"
}

_envtpl /etc/odoo/odoo.conf

# set odoo database host, port, user and password
: ${PGHOST:=$DB_PORT_5432_TCP_ADDR}
: ${PGPORT:=$DB_PORT_5432_TCP_PORT}
: ${PGUSER:=${DB_ENV_POSTGRES_USER:='postgres'}}
: ${PGPASSWORD:=$DB_ENV_POSTGRES_PASSWORD}

CONFIG=/etc/odoo/odoo.conf

case "$1" in
	--)
		shift
		exec odoo "$@" --config $CONFIG
		;;
	-*)
		exec odoo "$@" --config $CONFIG
		;;
	*)
		exec "$@" --config $CONFIG
esac

exit 1

