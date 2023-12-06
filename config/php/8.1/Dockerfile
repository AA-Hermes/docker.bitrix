FROM php:8.1.23-fpm-alpine3.18

RUN docker-php-source extract \
    # do important things \
    && docker-php-source delete

RUN apk update && apk add --no-cache \
    # php81-pear \
    # php81-mysqli \
    # php81-pdo_mysql \
    php81-mbstring \
    php81-intl \
    php81-pecl-imagick \
    php81-soap \
    php81-gd \
    php81-opcache \
    php81-zip \
    libc-dev \
    autoconf \
    make \
    gcc

# magic installation of mysql & opcache
RUN docker-php-ext-install mysqli opcache
# RUN pecl install xdebug-3.2.1
# RUN docker-php-ext-enable xdebug

RUN apk del gcc make autoconf libc-dev \
    && rm -rf /var/cache/apk/*

ADD ./php.ini /etc/php/8.1/fpm/conf.d/90-php.ini
ADD ./php.ini /etc/php/8.1/cli/conf.d/90-php.ini

WORKDIR "/var/www/bitrix"

EXPOSE 9000
