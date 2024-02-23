FROM php:7.4-fpm

RUN apt-get update && apt-get install -y nodejs npm
RUN apt-get update && apt-get install default-mysql-client -y

RUN apt-get update && \
    requirements="git cron rsync vim libpng-dev libmcrypt-dev libmcrypt4 libcurl3-dev libfreetype6 libjpeg62-turbo libjpeg62-turbo-dev libpng-dev libfreetype6-dev libicu-dev libxslt1-dev libzip-dev  unzip libc-client-dev libkrb5-dev libonig-dev" && \
    apt-get install -y $requirements && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install -j$(nproc) pdo_mysql


RUN docker-php-ext-install -j$(nproc) mbstring
RUN docker-php-ext-install -j$(nproc) zip
RUN docker-php-ext-install -j$(nproc) intl
RUN docker-php-ext-install -j$(nproc) xsl
RUN docker-php-ext-install -j$(nproc) soap
RUN docker-php-ext-install -j$(nproc) bcmath
RUN docker-php-ext-install -j$(nproc) opcache
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install -j$(nproc) imap
RUN docker-php-ext-install -j$(nproc) sockets

RUN printf "\n\n\n" | pecl install redis-4.0.0 && \
    docker-php-ext-enable redis

WORKDIR /code

RUN pecl install xdebug-3.1.5
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update && apt-get install ssmtp -y
RUN echo "sendmail_path = /usr/sbin/ssmtp -t" > /usr/local/etc/php/conf.d/sendmail.ini
RUN echo "mailhub=mailcatcher:1025\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf

RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd 

RUN apt-get update && apt-get install openssh-server -y

COPY ./conf.d/* /usr/local/etc/php/conf.d/
COPY ./php-code/disable_xdebug.sh /
COPY ./php-code/enable_xdebug.sh /

RUN mkdir -p /root/.ssh/
COPY ./ssh/* /root/.ssh/
RUN chmod 700 /root/.ssh/
RUN chmod 600 -R /root/.ssh/authorized_keys

COPY ./zzz-docker.conf /usr/local/etc/php-fpm.d/zzz-docker.conf

CMD ["php-fpm", "-R"]