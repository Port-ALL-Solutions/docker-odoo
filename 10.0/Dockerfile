#Starting from the image maintain by Odoo
FROM odoo:10.0 

MAINTAINER Benoît "XtremXpert" Vézina <benoit@xtremxpert.com>

# Set the default config file
ENV OPENERP_SERVER='/etc/odoo/openerp-server.conf' \
	PGHOST='db' \
        PGUSER='dbuser' \
        PGPSWD='dbpass' \
        DBADMPASS='adminpass' \
	VERSION='01-11-17.01'

# Switching back from runing user (odoo) to root user
USER root

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
# First curl is not use cause not added the postgres repo
RUN	curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
	echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/postgres.list && \
	apt-get update && \
# Adding nodejs repos
	curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
	apt-get dist-upgrade -y && \
	apt-get install -y \
		build-essential \
		git \
#		libffi6 \
		libffi-dev \
		libssl-dev \
		nodejs \
#		postgresql-client-9.5 \
		python-dev \
		unzip && \

# Python dependecies
	pip install \
#		envtpl \
		num2words \
		phonenumbers \
		pysftp && \
#            	pymysql \
#            	soappy && \

# Installation de clean-css via node-js
	npm install -g less less-plugin-clean-css

# Adding a little more stuff from OCA and Odoo apps store
RUN mkdir /tmp/OCA /tmp/ODOO /mnt/docker-addons && \
	cd /tmp/OCA && \
	git clone https://github.com/OCA/server-tools.git && \
	git clone https://github.com/OCA/partner-contact.git && \
 	git clone https://github.com/OCA/connector-telephony.git && \
	git clone https://github.com/OCA/project.git && \
	git clone https://github.com/OCA/web.git && \
	mv server-tools/auto_backup /mnt/docker-addons/ && \
	mv partner-contact/base_location /mnt/docker-addons/ && \
	mv partner-contact/base_partner_sequence /mnt/docker-addons/ && \
	mv partner-contact/partner_contact_gender /mnt/docker-addons/ && \
	mv partner-contact/partner_contact_personal_information_page /mnt/docker-addons/ && \
	mv partner-contact/partner_firstname /mnt/docker-addons/ && \
	mv partner-contact/partner_identification /mnt/docker-addons/ && \
	mv connector-telephony/base_phone /mnt/docker-addons/ && \
	mv project/project_description /mnt/docker-addons/ && \
	mv project/project_task_default_stage /mnt/docker-addons/ && \
	mv project/project_task_dependency /mnt/docker-addons/ && \
	mv web/web_favicon /mnt/docker-addons/ && \
	mv web/web_responsive /mnt/docker-addons/ && \
	cd /tmp/ODOO && \
	curl -sL -o website-animate.zip https://apps.odoo.com/loempia/download/website_animate/10.0.1.1/2SQQrz8rCw3U0qeOVrgm9A.zip?deps && \
	curl -sL -o google-map-snippet.zip https://apps.odoo.com/loempia/download/snippet_google_map/10.0.1.1/10KtivJ3MWzmwgMzPkTzqh.zip?deps && \
	curl -sL -o latest-post-snippet.zip https://apps.odoo.com/loempia/download/snippet_latest_posts/10.0.1.1/7gDzwQ8V9xPau2kvaf8njT.zip && \
	unzip '*.zip' && \
	rm -rf *.zip && \
	mv * /mnt/docker-addons	&& \
# Adding that /mnt/docker-addons to the list of addons dir
	sed -i 's/extra-addons/extra-addons,\/mnt\/docker-addons/g' /etc/odoo/odoo.conf

#switch back to runing user odoo
USER odoo
