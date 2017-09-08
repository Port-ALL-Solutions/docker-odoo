#!/bin/bash
set -e


#Change the uid/gid of odoo if they are set
if [ "$(id -u)" != ${ODOO_UID} ]; then	
	echo "Not the wanted UID for odoo!"
	usermod -u ${ODOO_UID} odoo    
	groupmod -g ${ODOO_GID} odoo
	usermod -g ${ODOO_GID} odoo
	echo "UID and GID changed"
fi

# set the postgres database host, port, user and password according to the environment
# and pass them as arguments to the Odoo process if not present in the config file
: ${PGHOST:=${DB_PORT_5432_TCP_ADDR:='db'}}
: ${PGPORT:=${DB_PORT_5432_TCP_PORT:=5432}}
: ${PGUSER:=${DB_ENV_POSTGRES_USER:=${POSTGRES_USER:='odoo'}}}
: ${PGPASSWORD:=${DB_ENV_POSTGRES_PASSWORD:=${POSTGRES_PASSWORD:='odoo'}}}

#DB_ARGS=("--config=${ODOO_CONFIG}" "--logfile=${ODOO_LOG}")
#DB_ARGS=("--config=/etc/odoo/odoo.conf" "--logfile=/var/log/odoo/odoo.log")
DB_ARGS=("--config=/etc/odoo/odoo.conf")

ADDONS=("/usr/lib/python2.7/dist-packages/odoo/addons" \
        "/mnt/extra-addons" \
        )

# Check if there is a odoo.conf, if not create it
if [ ! -f /etc/odoo/odoo.conf ]; then
    echo "No Configuration file found!"
	cp /root/odoo.conf /etc/odoo/
#TODO: Generate the configuration file then make some change to it instead copying from /root/ 
#if [ ! -f /etc/odoo/odoo.conf ]; then
#    exec su-exec odoo odoo --save --config $ODOO_CONFIG 
#    echo "Disabling addons_path in the config file as we pass it as arguments"
#    sed -i '/addons_path/d' $ODOO_CONFIG
#    echo "Setting the database password and user"
#    sed -i '/^db_password =/s/=.*/= odoo/' $ODOO_CONFIG
#    sed -i '/^db_user =/s/=.*/= odoo/' $ODOO_CONFIG
#    echo "Setting the filestore directory"
#    sed -i 's/\/home\/odoo\/.local\/share\/Odoo/\/var\/lib\/odoo/g' $ODOO_CONFIG
    echo "Configuration file created"
fi

# Install requirements.txt and oca_dependencies.txt from root of mount
if [[ "${SKIP_DEPENDS}" != "1" ]] ; then
	echo "Install requirements.txt and oca_dependencies.txt from root of mount"

    export VERSION=$ODOO_VERSION
    clone_oca_dependencies /opt/community /mnt/extra-addons

    # Iterate the newly cloned addons & add into possible dirs
    for dir in /opt/community/*/ ; do
    	echo "Processing $dir"
        ADDONS+=("$dir")
    done
	echo ${ADDONS[*]}
    VALID_ADDONS="$(get_addons ${ADDONS[*]})"
    DB_ARGS+=("--addons-path=${VALID_ADDONS}")
    echo "Suppressing not installable module"
	grep -l -r -i "'installable': False" /opt/community/* | sed 's/__manifest__.py//' | xargs rm -rf
fi

echo "Dependecies Processed"

# Pull database from config file if present & validate
function check_config() {
    param="$1"
    value="$2"
    if ! grep -q -E "^\s*\b${param}\b\s*=" "$ODOO_CONFIG" ; then
        DB_ARGS+=("--${param}")
        DB_ARGS+=("${value}")
   fi;
}
check_config "db_host" "$PGHOST"
check_config "db_port" "$PGPORT"
check_config "db_user" "$PGUSER"
check_config "db_password" "$PGPASSWORD"

# Change ownership to odoo for Volume and OCA
echo "change ownership to odoo"
chown -R odoo:odoo \
	/etc/odoo \
	/var/lib/odoo \
	/opt/community \
	/mnt/extra-addons

echo "Printing all the db_args"
echo ${DB_ARGS[@]}

# Execute
case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec su-exec odoo odoo "$@"
        else
            exec su-exec odoo odoo "$@" "${DB_ARGS[@]}"
        fi
        ;;
    -*)
        exec su-exec odoo odoo "$@" "${DB_ARGS[@]}"
        ;;
    *)
        "$@"
esac

exit 1
