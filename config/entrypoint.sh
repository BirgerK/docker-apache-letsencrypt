#!/bin/bash

# init only if lets-encrypt is running for the first time
([ ! -d $LETSENCRYPT_HOME ] || [ ! "$(ls -A $LETSENCRYPT_HOME)" ]) && /init_letsencrypt.sh --domains $DOMAINS && service apache2 stop

# run supervisor, which runs apache and cron
/usr/bin/supervisord
