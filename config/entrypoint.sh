#!/bin/bash

# if init-file does not exist, template it.
[ ! -f /init_letsencrypt.sh ] && dockerize -template /init_letsencrypt.sh.j2:/init_letsencrypt.sh && chmod a+x /*.sh

/init_letsencrypt.sh

# run supervisor, which runs apache and cron
/usr/bin/supervisord
