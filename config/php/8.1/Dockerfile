FROM node:20.4.0
FROM php:8.1-fpm

RUN docker-php-source extract && docker-php-source delete
RUN apt-get --fix-missing update && apt-get install -y \
    nano \
    wget \
    curl \
    # install PHP extension compile dependencies foor pecl
    $PHPIZE_DEPS

# Extensions:
# Install dependencies for GD and install GD with support for jpeg, png webp and freetype
# Info about installing GD in PHP https://www.php.net/manual/en/image.installation.php
RUN apt-get install -y libpng-dev zlib1g-dev && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql mysqli
# RUN docker-php-ext-install -j$(nproc) gd sockets bcmath zip pdo_mysql intl exif
# RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/

# Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# mcrypt
RUN pecl install mcrypt

# Memcache
RUN apt-get install -y libmemcached-dev zlib1g-dev libssl-dev \
    && pecl install memcache \
    && docker-php-ext-enable memcache

# Opcache
RUN docker-php-ext-install opcache && docker-php-ext-enable opcache

# SOAP
RUN apt-get install -y libxml2-dev && docker-php-ext-install soap

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# COPY composer.json /app
# RUN composer install --working-dir=/app || composer update --working-dir=/app

# clear temp files
RUN apt-get autoremove --purge -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./php.ini /usr/local/etc/php/conf.d/php.ini
ADD ./php.ini /etc/php/8.1/fpm/conf.d/php.ini
ADD ./php.ini /etc/php/8.1/cli/conf.d/php.ini

WORKDIR "/var/www/bitrix"

EXPOSE 9000
