# Docker - Apache with Let's Encrypt

This is a debian-based image which runs an apache and get's it SSL-certificates automatically from Let's Encrypt.

A cron-job renews the certificates automatically, so you don't have to care about it.

## Instructions

### Run it
For an easy test-startup you just have to:
```
  $ docker run -d --name syncserver birgerk/apache-letsencrypt
```

Now you have locally an apache running, which get's it SSL-certificates from Let's Encrypt.


### Configuring docker-container
It's possible to configure the docker-container by setting the following environment-variables at container-startup:
* `DOMAINS`, configures which for which domains a SSL-certificate shall be requested from Let's Encrypt, default is `""`. Must be given as comma-seperated list, f.e.: `"example.com,my-internet.org,more.example.com"`.
* `WEBMASTER_MAIL`, Let's Encrypt needs a mail-address from the webmaster of the requested domain. You have to set it, otherwise Let's Encrypt won't give the certificates. Default is `""`. Must be given as simple mail-address, f.e.: `"webmaster@example.com"`.
