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
    # for gd
    # zlib1g-dev libpng-dev

# Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug;

# magic installation of mysql & opcache
# RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    # && docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install mysqli opcache

# Install dependencies for GD and install GD with support for jpeg, png webp and freetype
# Info about installing GD in PHP https://www.php.net/manual/en/image.installation.php
RUN apk add --no-cache \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    freetype-dev
# As of PHP 7.4 we don't need to add --with-png
RUN docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype
RUN docker-php-ext-install gd

# clear temp files
RUN apk del gcc make autoconf libc-dev \
    && rm -rf /var/cache/apk/*

ADD ./php.ini /etc/php/8.1/fpm/conf.d/90-php.ini
ADD ./php.ini /etc/php/8.1/cli/conf.d/90-php.ini

WORKDIR "/var/www/bitrix"

EXPOSE 9000
