FROM debian:8
MAINTAINER BirgerK <birger.kamp@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LETSENCRYPT_HOME /etc/letsencrypt
ENV DOCKERIZE_VERSION v0.2.0

# Base setup
# ADD resources/etc/apt/ /etc/apt/
RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get install -q -y supervisor cron curl apache2 nano && \
    apt-get install -y python-certbot-apache -t jessie-backports && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install dockerize
RUN curl -L -O https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm -rf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# configure apache
RUN echo "ServerName localhost" >> /etc/apache2/conf-enabled/hostname.conf && \
    a2enmod ssl headers proxy proxy_http proxy_html xml2enc rewrite usertrack && \
    a2dissite 000-default default-ssl && \
    mkdir -p /var/lock/apache2 && \
    mkdir -p /var/run/apache2

# configure supervisor
ADD config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD config/supervisord/supervisord_apache.conf /etc/supervisor/conf.d/supervisord_apache.conf
ADD config/supervisord/supervisord_cron.conf /etc/supervisor/conf.d/supervisord_cron.conf

# add start-stuff
ADD config/init_letsencrypt.sh.j2 /init_letsencrypt.sh.j2
ADD config/entrypoint.sh /entrypoint.sh
RUN chmod +x /*.sh

# Run the Sync server
EXPOSE 80
EXPOSE 443
VOLUME [ "$LETSENCRYPT_HOME", "/etc/apache2/sites-available" ]
ENTRYPOINT ["/entrypoint.sh"]
