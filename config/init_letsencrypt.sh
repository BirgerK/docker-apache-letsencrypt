#!/bin/bash

certbot -n --expand --apache --agree-tos --email $WEBMASTER_MAIL "$@"
