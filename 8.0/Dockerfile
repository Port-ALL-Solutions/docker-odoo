FROM ubuntu:xenial

MAINTAINER Benoît "XtremXpert" Vézina <benoit@xtremxpert.com>

COPY 	./rootfs/ /

# Set the default config file
ENV 	OPENERP_SERVER='/etc/odoo/openerp-server.conf' \
	PGHOST='db' \
        PGUSER='odoouser' \
        PGPSWD='odoopass' \
        DBADMPASS='adminpas' \
#        DBNAME='dbname' \
#        DBFILTER='dbfilter' \
        VERSION='1.9-ubuntu' \
	ODOO_VERSION='8.0' \
	ODOO_RELEASE='20161018'

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN 	set -x; \
        apt-get update \
	&& apt-get dist-upgrade -y \
        && apt-get install -y \
            curl \
 	&& curl -sL https://deb.nodesource.com/setup_4.x | bash - \
        && apt-get install -y \
#           build-essential \
            ca-certificates \
            git \
	    nodejs \
#            node-less \
#            node-clean-css \
            libffi-dev \
            libssl-dev \
	    python-dev \
            python-pip \
            python-pyinotify \
            python-renderpm \
            wkhtmltopdf \

# Install Odoo
        && curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
        && echo 'a845b017b46c5ea034e28e595f207bb0adfbf815 odoo.deb' | sha1sum -c - \
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
	&& npm install -g less less-plugin-clean-css \
# Adding some OCA stuff
#	&& mkdir /tmp/OCA /mnt/docker-addons \
# ADDED FOR DEBUGING AND CREATE QUICKER COMPILE BUT BIGGER IMAGES
	&& mkdir /tmp/OCA /mnt/docker-addons
RUN	cd /tmp/OCA \
#	&& cd /tmp/OCA \
# For changing taxes on commun rules
	&& git clone -b 8.0 https://github.com/OCA/account-fiscal-rule.git  \
	&& mv /tmp/OCA/account-fiscal-rule/account_fiscal_position_rule  /mnt/docker-addons/  \
	&& mv /tmp/OCA/account-fiscal-rule/account_fiscal_position_rule_purchase  /mnt/docker-addons/  \
	&& mv /tmp/OCA/account-fiscal-rule/account_fiscal_position_rule_sale  /mnt/docker-addons/  \
	&& mv /tmp/OCA/account-fiscal-rule/account_fiscal_position_rule_stock  /mnt/docker-addons/  \

# RMA Stuff for return
	&& git clone -b 8.0 https://github.com/OCA/rma.git \
	&& mv /tmp/OCA/rma/product_warranty /mnt/docker-addons/ \
	&& mv /tmp/OCA/rma/crm_claim_rma /mnt/docker-addons/ \
	&& mv /tmp/OCA/rma/crm_claim_rma_code /mnt/docker-addons/ \

	&& git clone -b 8.0 https://github.com/OCA/crm.git \
	&& mv /tmp/OCA/crm/crm_claim_code /mnt/docker-addons/ \
	&& mv /tmp/OCA/crm/crm_claim_type /mnt/docker-addons/ \

#Some E-commerce add-ons
	&& git clone -b 8.0 https://github.com/OCA/e-commerce.git \
	&& mv /tmp/OCA/e-commerce/website_sale_require_login /mnt/docker-addons/ \
	&& mv /tmp/OCA/e-commerce/website_sale_suggest_create_account /mnt/docker-addons/ \

	&& git clone -b 8.0 https://github.com/OCA/website.git \
	&& mv /tmp/OCA/website/website_menu_by_user_status /mnt/docker-addons/ \
	&& mv /tmp/OCA/website/website_portal /mnt/docker-addons/ \
	&& mv /tmp/OCA/website/website_portal_sale /mnt/docker-addons/ \

	&& git clone -b 8.0 http://gitlab.opengest.solutions/OCA/connector-telephony.git \
	&& mv /tmp/OCA/connector-telephony/base_phone /mnt/docker-addons/ \

	&& git clone -b 8.0 https://github.com/OCA/partner-contact.git \
	&& mv /tmp/OCA/partner-contact/base_location /mnt/docker-addons/ \
	&& mv /tmp/OCA/partner-contact/partner_contact_birthdate /mnt/docker-addons/ \
	&& mv /tmp/OCA/partner-contact/partner_firstname /mnt/docker-addons/ \
	&& mv /tmp/OCA/partner-contact/partner_contact_gender /mnt/docker-addons/ \
	&& mv /tmp/OCA/partner-contact/partner_second_lastname /mnt/docker-addons/ \
	&& mv /tmp/OCA/partner-contact/partner_contact_personal_information_page /mnt/docker-addons/ \

	&& git clone -b 8.0 https://github.com/OCA/server-tools.git \
	&& mv /tmp/OCA/server-tools/auditlog /mnt/docker-addons/ \
	&& mv /tmp/OCA/server-tools/auto_backup /mnt/docker-addons/ \
	&& mv /tmp/OCA/server-tools/web_context_tunnel /mnt/docker-addons/ \

	&& git clone -b 8.0 https://github.com/OCA/vertical-association.git \
	&& mv /tmp/OCA/vertical-association/membership_variable_period /mnt/docker-addons/ \

	&& git clone -b 8.0 https://github.com/OCA/l10n-canada.git \
	&& mv /tmp/OCA/l10n-canada/res_partner_attributes_add_BN /mnt/docker-addons/ \
	&& mv /tmp/OCA/l10n-canada/res_partner_attributes_add_NEQ /mnt/docker-addons/ \
	&& mv /tmp/OCA/l10n-canada/res_partner_attributes_add_SIN /mnt/docker-addons/ \
	&& mv /tmp/OCA/l10n-canada/l10n_ca_qc_account_fiscal_position_rule /mnt/docker-addons/  \
	&& mv /tmp/OCA/l10n-canada/l10n_ca_toponyms /mnt/docker-addons/ \

# Use the odoo config file from the rootfs
	&& mv /etc/odoo/openerp-server.conf /etc/odoo/openerp-server.conf.deb \
	&& mv /etc/odoo/openerp-server.conf.docker /etc/odoo/openerp-server.conf \

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
	&& mkdir -p /mnt/extra-addons \
        && chown -R odoo /mnt/extra-addons /etc/odoo \

# Some clean up
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* odoo.deb wkhtmltox.deb \

VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071


# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server"]
