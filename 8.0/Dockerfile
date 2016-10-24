FROM ubuntu:xenial

MAINTAINER Benoît "XtremXpert" Vézina <benoit@xtremxpert.com>

ENV PGHOST=db \
        PGUSER=odoo \                   # The Postgres user for odoo
        PGPSWD=odoo \                   # Password for the Postgres user
        DBADMPASS='R3!v4P4ss' \         # Password for the database manager
        DBNAME='Reiva' \                # The Database name for DBname & DBfilter
        VERSION=1.9-ubuntu \            # Internal version numbre
        ODOO_VERSION=8.0 \              # version to clone
        ODOO_RELEASE=20161018           # Date of the build

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            git \
            node-less \
            node-clean-css \
            libffi-dev \
            libssl-dev \
            python-pip \
            python-pyinotify \
            python-renderpm \
        && pip install \
            envtpl \
            phonenumbers \       
            pymysql \                   # Can be remove, use to access MySQL db
            pysftp \                    # Use for sftp
            soappy \                    # Can be remove, use for SOAP
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb \
        && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

# Install Odoo

RUN set -x; \
        curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
        && echo 'a845b017b46c5ea034e28e595f207bb0adfbf815 odoo.deb' | sha1sum -c - \
        && dpkg --force-depends -i odoo.deb \
        && apt-get update \
        && apt-get -y install -f --no-install-recommends \
        && rm -rf /var/lib/apt/lists/* odoo.deb

# Copy entrypoint script and Odoo configuration file
COPY rootfs /
RUN chown odoo /etc/odoo/openerp-server.conf

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN mkdir -p /mnt/extra-addons \
        && chown -R odoo /mnt/extra-addons
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV OPENERP_SERVER /etc/odoo/openerp-server.conf

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server"]
