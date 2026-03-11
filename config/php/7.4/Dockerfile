FROM node:20.4.0
FROM php:7.4-fpm

# Base build dependencies and runtime libs used by docker-php-ext-* and pecl modules.
RUN apt-get update && apt-get install -y \
	nano \
	wget \
	curl \
	webp \
	jpegoptim \
	optipng \
	pngquant \
	gifsicle \
	libpng-dev \
	libwebp-dev \
	libjpeg62-turbo-dev \
	libfreetype6-dev \
	libicu-dev \
	libxml2-dev \
	libzip-dev \
	libmagickwand-dev \
	libmemcached-dev \
	zlib1g-dev \
	libssl-dev \
	libmcrypt-dev \
	libonig-dev \
	firebird-dev \
	$PHPIZE_DEPS

# Core extensions compiled from bundled PHP sources.
RUN docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype \
	&& docker-php-ext-install -j$(nproc) \
	bcmath \
	exif \
	gd \
	intl \
	mbstring \
	mysqli \
	opcache \
	pdo \
	pdo_mysql \
	soap \
	zip

# Extensions distributed via PECL (pin versions for stable reproducible builds).
RUN pecl install \
	imagick \
	memcache-4.0.5.2 \
	memcached-3.2.0 \
	mcrypt-1.0.4 \
	xdebug-3.1.6 \
	&& docker-php-ext-enable imagick memcache memcached mcrypt xdebug

# Keep composer available in the container for project dependency operations.
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Remove apt caches to keep image size smaller.
RUN apt-get autoremove --purge -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Local PHP/FPM overrides for this environment.
ADD ./php.ini /usr/local/etc/php/conf.d/php.ini
COPY ./www-custom.conf /usr/local/etc/php-fpm.d/zz-www-custom.conf

RUN usermod -u 1000 www-data
WORKDIR "/var/www/bitrix"
EXPOSE 9000
