FROM php:8.1.17-fpm-alpine

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
    php8.1-memcached \
    php8.1-memcache \
    php8.1-mbstring \
    php8.1-mysql \
    php8.1-intl \
    php8.1-xdebug \
    php8.1-interbase \
    php8.1-soap \
    php8.1-gd \
    php8.1-imagick \
    php8.1-opcache \
    php8.1-zip \
    php-pear php-dev libmcrypt-dev gcc make autoconf libc-dev pkg-config \
    && pecl install mcrypt-1.0.3 \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

ADD ./php.ini /etc/php/8.1/fpm/conf.d/90-php.ini
ADD ./php.ini /etc/php/8.1/cli/conf.d/90-php.ini

#Add UID '1000' to www-data
# RUN usermod -u 1000 www-data
# RUN adduser -G www-data -u 1000 -H $user
# RUN addgroup -S -g 1000 www-data
# RUN adduser -S -D -u 1000 -G $user $user

WORKDIR "/var/www/bitrix"

EXPOSE 9000
