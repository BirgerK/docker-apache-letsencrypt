#!/bin/bash

letsencrypt -n --expand --apache --agree-tos --email $WEBMASTER_MAIL "$@"
