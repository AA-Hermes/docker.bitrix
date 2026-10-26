FROM mysql:8.0

ADD my.cnf /etc/mysql/conf.d/my.cnf
COPY docker-entrypoint-permissions.sh /usr/local/bin/docker-entrypoint-permissions.sh

RUN sed -i 's/\r$//' /usr/local/bin/docker-entrypoint-permissions.sh \
    && chmod +x /usr/local/bin/docker-entrypoint-permissions.sh

ENTRYPOINT ["docker-entrypoint-permissions.sh"]
CMD ["mysqld"]

EXPOSE 3306
