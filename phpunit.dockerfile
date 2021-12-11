# https://stackoverflow.com/questions/51443557/how-to-install-php-composer-inside-a-docker-container
# https://gist.github.com/hkulekci/be8f126742c1089f5fc50d6bc9e1c713

# PHPUnit Docker Container. 
FROM php:8.0-fpm

# Run some Debian packages installation.
RUN apt update \
    && apt install -yqq \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libmcrypt-dev \
    default-mysql-client \
    libmagickwand-dev \
    --no-install-recommends \
    && pecl install imagick mcrypt \
    && docker-php-ext-enable imagick mcrypt \
    && docker-php-ext-install pdo_mysql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

# Install XDebug
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=remote" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=coverage,develop" >> /usr/local/etc/php/conf.d/xdebug.ini

# Get latest Composer && install phpunit
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require "phpunit/phpunit"

ENV PATH /root/.composer/vendor/bin:$PATH

RUN ln -s /root/.composer/vendor/bin/phpunit /usr/bin/phpunit
