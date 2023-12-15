FROM arm64v8/php:7.1-fpm
MAINTAINER wanghao <wanghao@ninghao.net>

ENV PHPREDIS_VERSION 3.0.0

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

RUN apt-get update 
RUN apt-get install -y libpng-dev libjpeg-dev libzip-dev
RUN rm -rf /var/lib/apt/lists/* 
RUN pecl update-channels
RUN pecl install zip
RUN docker-php-ext-enable zip \
  && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
  && docker-php-ext-install gd mysqli pdo_mysql zip opcache redis bcmath

COPY ./config/php.ini /usr/local/etc/php/conf.d/
COPY ./config/opcache-recommended.ini /usr/local/etc/php/conf.d/
