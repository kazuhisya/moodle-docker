# vi: set ft=dockerfile :
FROM alpine:3.6

ENV TZ="Asia/Tokyo" \
    MOODLE_VERSION="stable33" \
    MOODLE_TAG="latest-33"

RUN apk --update add \
        apache2 \
        bash \
        curl \
        php5 \
        php5-apache2 \
        php5-ctype \
        php5-curl \
        php5-dom \
        php5-gd \
        php5-iconv \
        php5-intl \
        php5-json \
        php5-opcache \
        php5-openssl\
        php5-pgsql \
        php5-soap \
        php5-xmlreader \
        php5-xmlrpc \
        php5-zip \
        php5-zlib \
        postgresql-client && \
        rm -f /var/cache/apk/*

WORKDIR /var/www/localhost/htdocs
RUN curl -OL https://download.moodle.org/${MOODLE_VERSION}/moodle-${MOODLE_TAG}.tgz && \
    tar xf moodle-${MOODLE_TAG}.tgz && \
    rm -rf moodle-${MOODLE_TAG}.tgz

RUN mkdir -p /var/www/moodledata && \
    echo "date.timezone = '${TZ}'\n" > /etc/php5/conf.d/timezone.ini && \
    sed -ri \
        -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
        -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
        "/etc/apache2/httpd.conf"

COPY config.php /var/www/localhost/htdocs/moodle/config.php
COPY index.html /var/www/localhost/htdocs/index.html
COPY start.sh /root/start.sh

CMD /root/start.sh
