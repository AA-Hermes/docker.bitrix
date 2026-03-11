FROM alpine:3.20

RUN apk add --no-cache logrotate

COPY logrotate.conf /etc/logrotate.conf

CMD ["sh", "-c", "mkdir -p /var/lib/logrotate && touch /var/lib/logrotate/status && while true; do logrotate -s /var/lib/logrotate/status /etc/logrotate.conf; sleep ${LOGROTATE_INTERVAL:-3600}; done"]