#!/bin/bash
if (! [ -z "$STAGING" ]) then
  echo "Using Let's Encrypt Staging environment..."
  letsencrypt -n --staging --expand --apache --agree-tos --email $WEBMASTER_MAIL "$@"
else
  echo "Using Let's Encrypt Productioun environment..."
  letsencrypt -n --expand --apache --agree-tos --email $WEBMASTER_MAIL "$@"
fi