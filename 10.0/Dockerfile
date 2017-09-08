#Starting from the image maintain by Odoo
FROM odoo:10.0 

MAINTAINER Benoît "XtremXpert" Vézina <benoit@xtremxpert.com>

# Set the default Env variable
ENV PGHOST='db' \
    PGUSER='dbuser' \
    PGPASSWORD='dbpass' \
    DBADMPASS='adminpass' \
	VERSION='09-05-17.01' \
	ODOO_UID='1000' \
	ODOO_GID='1000' \
	MQT_URI='https://github.com/LasLabs/maintainer-quality-tools/archive/bugfix/script-shebang.tar.gz'

# Switching back from runing user (odoo) to root user
USER root

# Install some deps, lessc and less-plugin-clean-css, wkhtmltopdf and update version of postgres=client
RUN	curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
	&& echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/postgres.list \
	&& apt-get update \

# Adding nodejs repos
	&& curl -sL https://deb.nodesource.com/setup_4.x | bash - \
	&& apt-get dist-upgrade -y \
	&& apt-get install -y \
		build-essential \
		git \
		libffi-dev \
		libssl-dev \
		nodejs \
		python-dev \
		unzip \

# Updating PIP so oca_clone_dependendies can work
	&& pip install --upgrade pip \

# Installation de clean-css via node-js
	&& npm install -g less less-plugin-clean-css \

# Installing su-exec to allow to swith user to odoo in the entrypoint	
	&& cd /tmp \
	&& git clone https://github.com/ncopa/su-exec \
	&& cd su-exec \
	&& make \
	&& mv su-exec /usr/bin/ \

# Installing the OCA maintainer-quality-tools
	&& curl -sL "$MQT_URI" | tar -xz -C /opt/ \
    && ln -s /opt/maintainer-quality-tools-*/travis/clone_oca_dependencies /usr/bin \
    && ln -s /opt/maintainer-quality-tools-*/travis/getaddons.py /usr/bin/get_addons \
    && chmod +x /usr/bin/get_addons \
    && mkdir -p /opt/community

COPY ./rootfs/ /