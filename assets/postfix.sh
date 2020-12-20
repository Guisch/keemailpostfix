#!/bin/bash

postconf -e smtputf8_enable=no

postconf -e myhostname=${HOSTNAME}

# disable local delivery
postconf -e mydestination=

# don't relay for any domains
postconf -e relay_domains=

# reject invalid HELOs
postconf -e smtpd_delay_reject=yes
postconf -e smtpd_helo_required=yes
postconf -e "smtpd_helo_restrictions=permit_mynetworks,reject_invalid_helo_hostname,permit"

postconf -e "smtpd_relay_restrictions=permit_mynetworks permit_sasl_authenticated defer_unauth_destination"
postconf -e mynetworks_style=host
postconf -e mailbox_size_limit=0

# use TLS
postconf -e smtp_use_tls=yes
postconf -e smtp_tls_CAfile=/etc/ssl/certs/ca-certificates.crt

mysql -u "$MYSQL_USER" -p$MYSQL_PASSWORD -h "$MYSQL_HOST" <<EOF
DELIMITER //
CREATE PROCEDURE ${MYSQL_DB}.readupdate(IN recipient TEXT)
BEGIN
SELECT destination FROM aliases WHERE source = recipient;
UPDATE aliases SET last_used = NOW(), used_count = used_count + 1 WHERE source = recipient;
END //
DELIMITER ;
EOF

cat > /etc/postfix/mysql-virtual-alias-maps.cf <<EOF
user = ${MYSQL_USER}
password = ${MYSQL_PASSWORD}
hosts = ${MYSQL_HOST}
dbname = ${MYSQL_DB}
query = CALL readupdate('%s')
EOF

postconf -e "virtual_alias_domains=${DOMAIN}"
postconf -e virtual_alias_maps=mysql:/etc/postfix/mysql-virtual-alias-maps.cf 

# stop complaining about missing /etc/postfix/aliases.db file
postalias /etc/postfix/aliases

postmap /etc/postfix/virtual
/usr/sbin/postfix -c /etc/postfix start
