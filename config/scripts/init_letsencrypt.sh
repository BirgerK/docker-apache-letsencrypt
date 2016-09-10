#!/bin/bash

# init only if lets-encrypt is running for the first time and if DOMAINS was set
if ([ ! -d $LETSENCRYPT_HOME ] || [ ! "$(ls -A $LETSENCRYPT_HOME)" ]) && [ ! -z "$DOMAINS" ]; then
  /run_letsencrypt.sh --domains $DOMAINS
fi
