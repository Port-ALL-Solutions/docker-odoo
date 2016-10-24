#!/bin/bash
set -e

# Replace {{ ENV }} vars
_envtpl() {
  mv "$1" "$1.tpl" # envtpl requires files to have .tpl extension
  envtpl "$1.tpl"
}

_envtpl /etc/odoo/openerp-server.conf

# set odoo database host, port, user and password
: ${PGHOST:=$DB_PORT_5432_TCP_ADDR}
: ${PGPORT:=$DB_PORT_5432_TCP_PORT}
: ${PGUSER:=${DB_ENV_POSTGRES_USER:='postgres'}}
: ${PGPASSWORD:=$DB_ENV_POSTGRES_PASSWORD}

case "$1" in
	--)
		shift
		exec openerp-server "$@"
		;;
	-*)
		exec openerp-server "$@"
		;;
	*)
		exec "$@"
esac

exit 1

