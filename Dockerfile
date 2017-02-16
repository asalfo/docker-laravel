
From php:5.6-apache
MAINTAINER Salif Guigma <salif.guigma@gmail.com>


RUN buildDeps=" \
            		libfreetype6-dev \
            		libjpeg-dev \
            		libldap2-dev \
            		libmcrypt-dev \
            		libpng12-dev \
            		zlib1g-dev \
          "; \
          set -x \
          && apt-get update && apt-get install -y  $buildDeps --no-install-recommends \
          libicu-dev \
          vim \
          git \
          openssl \
          php5-gd \
          && apt-get clean \
          && rm -rf /var/lib/apt/lists/* \
          && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    	      php /usr/local/bin/composer self-update \
          && curl -sS -o /tmp/icu.tar.gz -L http://download.icu-project.org/files/icu4c/57.1/icu4c-57_1-src.tgz \
          && tar -zxf /tmp/icu.tar.gz -C /tmp \
          && cd /tmp/icu/source \
          && ./configure --prefix=/usr/local \
          && make && make install \
          && docker-php-ext-configure intl --with-icu-dir=/usr/local \
          && docker-php-ext-configure gd --enable-gd-native-ttf --with-jpeg-dir=/usr/lib/x86_64-linux-gnu --with-png-dir=/usr/lib/x86_64-linux-gnu --with-freetype-dir=/usr/lib/x86_64-linux-gnu \
          && docker-php-ext-install pdo pdo_mysql opcache intl sockets mbstring bcmath tokenizer mysqli gd \
          && a2enmod rewrite \
          && pecl install xdebug \
          && pecl clear-cache \
          && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini \
          && apt-get purge -y --auto-remove $buildDeps \
          && usermod -u 1000 www-data \
          && groupmod -g 1000 www-data \
          && usermod -s /bin/bash www-data \
          && echo "date.timezone = Europe/Madrid" >> $PHP_INI_DIR/conf.d/php.ini \
          && echo "short_open_tag = Off" >> $PHP_INI_DIR/conf.d/php.ini \
          && echo "memory_limit = 128M" >> $PHP_INI_DIR/conf.d/php.ini
