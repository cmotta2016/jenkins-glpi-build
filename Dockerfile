FROM php:7.3.4-apache
MAINTAINER Carlos Motta <motta.carlos08@gmail.com>

RUN chmod +x /usr/local/bin/*

## Install and enable requirement for GLPI
RUN apt-get update && apt-get install -y --no-install-recommends \
	libxml2-dev \
	libpng-dev \
	libjpeg-dev \
	libldap2-dev \
	libc-client-dev \
	libkrb5-dev \
	libssl-dev ; \
	rm -rf /var/lib/apt/lists/*  

RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/include --with-png-dir=/usr/include ; \
	docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ ; \
	docker-php-ext-configure imap --with-kerberos --with-imap-ssl ; \
	docker-php-ext-configure opcache ; \
	docker-php-ext-configure xmlrpc ; \
	docker-php-ext-install gd ldap mysqli imap opcache xmlrpc

RUN printf "\n" | pecl install apcu apcu_bc-beta
RUN echo extension=apcu.so > /usr/local/etc/php/php.ini
RUN docker-php-ext-enable apc

## Download GLPI package from github
ADD https://github.com/glpi-project/glpi/releases/download/9.4.2/glpi-9.4.2.tgz /tmp/glpi.tgz

ENTRYPOINT ["docker-php-entrypoint"]

COPY apache2-foreground /usr/local/bin/
COPY cas.tgz /var/www/html/
RUN pear install cas.tgz
RUN chmod +x /usr/local/bin/apache2-foreground
EXPOSE 80 443
CMD ["apache2-foreground"]
