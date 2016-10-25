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
        VERSION='1.9-ubuntu' \
	    ODOO_VERSION='10.0' \
	    ODOO_RELEASE='20161005'

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
#            wkhtmltopdf \
            wkhtmltopdf 

# Install Odoo
RUN 	set -x; \
        curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}rc1c.${ODOO_RELEASE}_all.deb \
#        && curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
        && echo '661ec52d205cea0d14418ed5e50cf6aacdd958b6 odoo.deb' | sha1sum -c - \
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
            soappy

#            soappy \

# Adding some OCA stuff
#	&& mkdir /tmp/OCA \
#	&& cd /tmp/OCA \


#	&& git clone http://gitlab.opengest.solutions/OCA/connector-telephony.git \
#	&& mv /tmp/OCA/connector-telephony/base_phone /mnt/docker-addons/ \

#	&& git clone https://github.com/OCA/partner-contact.git \
#	&& mv /tmp/OCA/partner-contact/partner_contact_birthdate /mnt/docker-addons/ \
#	&& mv /tmp/OCA/partner-contact/partner_firstname /mnt/docker-addons/ \
#	&& mv /tmp/OCA/partner-contact/partner_contact_gender /mnt/docker-addons/ \
#	&& mv /tmp/OCA/partner-contact/partner_second_lastname /mnt/docker-addons/ \
#	&& mv /tmp/OCA/partner-contact/partner_contact_personal_information_page /mnt/docker-addons/ \

#	&& git clone https://github.com/OCA/server-tools.git \
#	&& mv /tmp/OCA/server-tools/auditlog /mnt/docker-addons/ \
#	&& mv /tmp/OCA/server-tools/web_context_tunnel /mnt/docker-addons/ \

#	&& git clone https://github.com/OCA/vertical-association.git \
#	&& mv /tmp/OCA/vertical-association/membership_initial_fee /mnt/docker-addons/ \
#	&& mv /tmp/OCA/vertical-association/membership_variable_period /mnt/docker-addons/ \

#	&& git clone https://github.com/OCA/l10n-canada.git \
#	&& mv /tmp/OCA/l10n-canada/res_partner_attributes_add_BN /mnt/docker-addons/ \
#	&& mv /tmp/OCA/l10n-canada/res_partner_attributes_add_NEQ /mnt/docker-addons/ \
#	&& mv /tmp/OCA/l10n-canada/res_partner_attributes_add_SIN /mnt/docker-addons/ \
#	&& mv /tmp/OCA/l10n-canada/l10n_ca_toponyms /mnt/docker-addons/
#	&& mv /tmp/OCA/l10n-canada/l10n_ca_toponyms /mnt/docker-addons/ \

# Use the odoo config file from the rootfs
#	&& mv /etc/odoo/openerp-server.conf /etc/odoo/openerp-server.conf.deb \
#RUN	mv /etc/odoo/odoo.conf /etc/odoo/odoo.conf.deb \
#	&& mv /etc/odoo/openerp-server.conf.docker /etc/odoo/odoo.conf \
RUN 	mv /etc/odoo/openerp-server.conf.docker /etc/odoo/odoo-server.conf \
	&& chown -R odoo /etc/odoo/ \

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
	&& mkdir -p /mnt/extra-addons \
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
CMD ["odoo"]

