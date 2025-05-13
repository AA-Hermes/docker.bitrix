FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    percona-toolkit \
    cron \
    bash \
    && apt-get clean

COPY analyze-log.sh /usr/local/bin/analyze-log.sh
COPY cronjob /etc/cron.d/pt-digest-cron

RUN chmod +x /usr/local/bin/analyze-log.sh && \
    chmod 0644 /etc/cron.d/pt-digest-cron && \
    crontab /etc/cron.d/pt-digest-cron

CMD ["cron", "-f"]
