#!/bin/bash
if (! [ -z "$STAGING" ]) then
  echo "Using Let's Encrypt Staging environment..."
  certbot -n --staging --expand --apache --agree-tos --email $WEBMASTER_MAIL "$@"
else
  echo "Using Let's Encrypt Production environment..."
  certbot -n --expand --apache --agree-tos --email $WEBMASTER_MAIL "$@"
fi
