# vi: set ft=dockerfile :
FROM php:apache

ENV TZ="Asia/Tokyo" \
    MOODLE_VERSION="stable33" \
    MOODLE_TAG="latest-33"

RUN apt-get update && \
    apt-get install --quiet --no-install-recommends -y \
        zlib1g-dev libpq-dev libpng12-dev libxml2-dev icu-devtools libicu-dev postgresql-client && \
    docker-php-ext-install -j$(nproc) \
        zip pgsql gd xmlrpc soap intl opcache && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
RUN curl -OL https://download.moodle.org/download.php/direct/${MOODLE_VERSION}/moodle-${MOODLE_TAG}.tgz && \
    tar xf moodle-${MOODLE_TAG}.tgz && \
    rm -rf moodle-${MOODLE_TAG}.tgz

COPY config.php /var/www/html/moodle/config.php
RUN mkdir -p /var/www/moodledata && \
    echo "date.timezone = '${TZ}'\n" > /usr/local/etc/php/conf.d/timezone.ini

COPY start.sh /root/start.sh
COPY index.html /var/www/html/index.html
CMD /root/start.sh
