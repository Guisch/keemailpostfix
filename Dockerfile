FROM alpine:3

RUN apk --no-cache add postfix postfix-mysql ca-certificates supervisor rsyslog bash mysql-client

COPY assets/postfix.sh /postfix.sh
COPY assets/supervisord.conf /etc/supervisord.conf
COPY assets/rsyslog.conf /etc/rsyslog.conf

RUN chmod +x /postfix.sh

EXPOSE 25

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
