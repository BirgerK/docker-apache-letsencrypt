#!/bin/bash
if (! [ -z "$STAGING" ]) then
  echo "Using Let's Encrypt Staging environment..."
  certbot -n --staging --expand --apache --agree-tos --email $WEBMASTER_MAIL "$@"
else
  echo "Using Let's Encrypt Production environment..."
  certbot -n --expand --apache --agree-tos --email $WEBMASTER_MAIL "$@"
fi

echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n"
for domain in ${2//,/$'\n'}; do
    le_file1=/etc/letsencrypt/live/$domain/fullchain.pem
    le_file2=/etc/letsencrypt/live/$domain/privkey.pem

    # ignore if letsencrypt files were not created (error in certbot process)
    if [ ! -f $le_file1 ] || [ ! -f $le_file2 ]; then continue; fi

    # searching the current domain in all enabled virtualhosts
    for virtualhost in /etc/apache2/sites-enabled/*; do
        # domain or virtualhost for port 80 not found
        if ! ( (grep -qE "ServerName +$domain" "$virtualhost") && (grep -qF "<VirtualHost *:80>" "$virtualhost") ) then continue; fi

        # if it's a symlink, change in the source file
        if [ -L "$virtualhost" ]; then virtualhost=$(readlink -f "$virtualhost"); fi;

        echo "Changing $virtualhost to redirect all traffic over port 80 to port 443..."

        sed -Ei '
        /^\s*<VirtualHost\s.*:80>\s*$/,/^\s*<\/VirtualHost>\s*$/{
            /^\s*<\/?VirtualHost.*>\s*$/b
            /^\s*ServerName\s+(\S+).*/!d
            s%%&\n    Redirect permanent / https://\1/%
        }' $virtualhost
    done
done
