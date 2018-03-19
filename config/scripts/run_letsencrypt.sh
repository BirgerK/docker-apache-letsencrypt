#!/bin/bash
#

case $STAGE in
  "production")
    echo "Using Let's Encrypt Production environment..."
    letsencrypt -n --expand --apache --agree-tos --email $WEBMASTER_MAIL "$@"
    ;;

  "staging")
    echo "Using Let's Encrypt Staging environment..."
    letsencrypt -n --staging --expand --apache --agree-tos --email $WEBMASTER_MAIL "$@"
    ;;

  "local")
    echo "Using Self signed certificates for Local environment..."
    OIFS=$IFS
    IFS=','
    for domain in ${DOMAINS}; do
      echo "---> Domain: ${domain}"
      mkdir -vp /etc/letsencrypt/live/${domain}

      SUBJ="/C=FR/ST=Paris/L=Paris/O=Org/OU=IT/CN=${domain}"

      openssl req -x509 \
        -nodes \
        -days 365 \
        -newkey rsa:2048 \
        -outform PEM \
        -keyout /etc/letsencrypt/live/${domain}/privkey.pem \
        -out /etc/letsencrypt/live/${domain}/fullchain.pem \
        -subj "${SUBJ}"
    done
    IFS=$OIFS
    echo "Done"
    ;;

  "*")
    echo "Unknown stage: $STAGE ..."
    exit 2
    ;;

esac
