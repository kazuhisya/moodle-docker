#!/bin/bash -eu

if [ ! -e /tmp/.db-setup ]; then

    until psql -h ${POSTGRES_HOST} -d ${POSTGRES_DB} -U ${POSTGRES_USER} -c '\l'; do
        >&2 echo "Postgres is unavailable - waiting..."
        sleep 1
    done

    echo "Start first setup"
    /usr/local/bin/php  /var/www/html/moodle/admin/cli/install_database.php \
        --agree-license \
        --adminuser="${MOODLE_ADMINUSR}" \
        --adminpass="${MOODLE_ADMINPWD}" \
        --adminemail="${MOODLE_ADMINEML}" \
        --fullname="${MOODLE_SITENAME}" \
        --shortname="${MOODLE_SITESHORT}" \
        --lang="${MOODLE_LANG}"
    chown -R www-data.www-data /var/www/moodledata
    chown -R www-data.www-data /var/www/html/moodle
    echo "Admin account: ${MOODLE_ADMINUSR}/${MOODLE_ADMINPWD}"

    touch /tmp/.db-setup
    echo "first setup done."
fi

apache2-foreground