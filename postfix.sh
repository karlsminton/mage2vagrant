#!/bin/bash

# Download all postfix necessities to run PHP mail()
wget -P ~/ https://www.thawte.com/roots/thawte_Premium_Server_CA.pem && \
    sudo mv ~/thawte_Premium_Server_CA.pem /usr/local/share/ca-certificates/thawte_Premium_Server_CA.crt && \
    sudo update-ca-certificates ;

# pre-answer interactive configuration for Postfix
sudo debconf-set-selections <<< "postfix postfix/mailname string local.dev"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

# Install deps
sudo apt-get install -y postfix mailutils libsasl2-2 ca-certificates libsasl2-modules

# update postfix mail to use gmail
# per https://easyengine.io/tutorials/linux/ubuntu-postfix-gmail-smtp/
# First, remove old relayhost entry
sudo sed -i.bak '/relayhost/,/^/d' /etc/postfix/main.cf

# Enter new information
# relayhost =[smtp.gmail.com]:587
echo "
relayhost = [localhost]:1025
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CAfile = /etc/postfix/cacert.pem
smtp_use_tls = yes" | sudo tee -a /etc/postfix/main.cf

# Add Gmail username:password.
# This should be setup using an application-specific password in the Google
echo "[smtp.gmail.com]:587  modgento@gmail.com:%C=tR2g#$Hn*4Ub_" | sudo tee -a /etc/postfix/sasl_passwd

# Add password to postfix settings
sudo chmod 400 /etc/postfix/sasl_passwd
sudo postmap /etc/postfix/sasl_passwd

# add CA Certs to Postfix
cat /etc/ssl/certs/thawt_Premium_Server_CA.pem | sudo tee -a /etc/postfix/cacert.pem

# Reload
sudo /etc/init.d/postfix reload
