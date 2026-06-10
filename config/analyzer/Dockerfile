FROM debian:trixie-slim

RUN set -eux; \
	apt-get -o Acquire::Retries=5 -o Acquire::http::Timeout=60 update; \
	DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::Retries=5 -o Acquire::http::Timeout=60 install -y --no-install-recommends \
		percona-toolkit \
		cron \
		bash; \
	rm -rf /var/lib/apt/lists/*

COPY analyze-log.sh /usr/local/bin/analyze-log.sh
COPY cronjob /etc/cron.d/pt-digest-cron

RUN chmod +x /usr/local/bin/analyze-log.sh && \
	chmod 0644 /etc/cron.d/pt-digest-cron && \
	crontab /etc/cron.d/pt-digest-cron

CMD ["cron", "-f"]
