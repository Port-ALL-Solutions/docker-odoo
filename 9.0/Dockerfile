FROM ubuntu:xenial

MAINTAINER Benoît "XtremXpert" Vézina <benoit@xtremxpert.com>

COPY 	./rootfs/ /

# Set the default config file
ENV 	OPENERP_SERVER='/etc/odoo/openerp-server.conf' \
	PGHOST='db' \
        PGUSER='odoo' \
        PGPSWD='odoo' \
        DBADMPASS='R3!v4P4ss' \
        DBNAME='Reiva' \
        VERSION='0.9-ubuntu' \
	ODOO_VERSION='9.0' \
	ODOO_RELEASE='20161025'

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN 	set -x; \
        apt-get update \
	&& apt-get dist-upgrade -y \
        && apt-get install -y \
            build-essential \
            ca-certificates \
            curl \
            git \
            node-less \
            node-clean-css \
            libffi-dev \
            libssl-dev \
	    python-dev \
            python-pip \
            python-pyinotify \
            python-renderpm \
            wkhtmltopdf \

# Install Odoo
        && curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}c.${ODOO_RELEASE}_all.deb \
        && echo '126f7dc1de2f3c6faf3c4b5958c46ba628691fef odoo.deb' | sha1sum -c - \
        && dpkg --force-depends -i odoo.deb \
        && apt-get update \
        && apt-get -y install -f --no-install-recommends \
# Add other usefull python dependencies
        && pip install \
            envtpl \
            num2words \
            phonenumbers \
            pymysql \
            pysftp \
            soappy \

# Copy entrypoint script and Odoo configuration file
    && chown odoo /etc/odoo/openerp-server.conf \

# Adding some OCA stuff
	&& mkdir /tmp/OCA \
	&& cd /tmp/OCA \

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
	&& mkdir -p /mnt/extra-addons \

#	&& git clone -b 9.0 https://github.com/OCA/website.git \
#	&& mv /tmp/OCA/website/* /mnt/extra-addons/ \

#	&& git clone -b 9.0 http://gitlab.opengest.solutions/OCA/connector-telephony.git \
#	&& mv /tmp/OCA/connector-telephony/* /mnt/extra-addons/ \

#	&& git clone -b 9.0 https://github.com/OCA/partner-contact.git \
#	&& mv /tmp/OCA/partner-contact/* /mnt/extra-addons/ \

#	&& git clone -b 9.0 https://github.com/OCA/server-tools.git \
#	&& mv /tmp/OCA/server-tools/* /mnt/extra-addons/ \

#	&& git clone -b 9.0 https://github.com/OCA/vertical-association.git \
#	&& mv /tmp/OCA/vertical-association/* /mnt/extra-addons/ \

	&& git clone -b 9.0 https://github.com/OCA/l10n-canada.git \
	&& mv /tmp/OCA/l10n-canada/* /mnt/extra-addons/ \

# Use the odoo config file from the rootfs
	&& mv /etc/odoo/openerp-server.conf /etc/odoo/openerp-server.conf.deb \
	&& mv /etc/odoo/openerp-server.conf.docker /etc/odoo/openerp-server.conf \

# Gave owner ship to odoo
    && chown -R odoo /mnt/extra-addons \

# Some clean up
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /tmp/OCA /var/lib/apt/lists/* odoo.deb wkhtmltox.deb \

VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071


# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server"]
