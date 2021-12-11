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
    && apt clean \
    && rm -rf /var/lib/apt/lists/* \    
    && docker-php-ext-install pdo_mysql \
    && pecl install xdebug imagick mcrypt \
    && docker-php-ext-enable imagick mcrypt xdebug 

# Get latest Composer && install phpunit
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require "phpunit/phpunit"

ENV PATH /root/.composer/vendor/bin:$PATH

RUN ln -s /root/.composer/vendor/bin/phpunit /usr/bin/phpunit
