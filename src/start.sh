#!/bin/bash -eu

# Confirm DB connection
until psql -h ${POSTGRES_HOST} -d ${POSTGRES_DB} -U ${POSTGRES_USER} -c '\l'; do
    >&2 echo "Postgres is unavailable - waiting..."
    sleep 1
done

# Does the database already exist?
if psql -h ${POSTGRES_HOST} -d ${POSTGRES_DB} -U ${POSTGRES_USER} -c '\dt' | cut -d \| -f 2 | grep -q mdl_ ; then
    # $? is 0
    # Database already exists
    echo "Skip first setup"
else
    # $? is 1
    # Database does not exist
    echo "Start first setup"
    /usr/bin/php /var/www/localhost/htdocs/moodle/admin/cli/install_database.php \
        --agree-license \
        --adminuser="${MOODLE_ADMINUSR}" \
        --adminpass="${MOODLE_ADMINPWD}" \
        --adminemail="${MOODLE_ADMINEML}" \
        --fullname="${MOODLE_SITENAME}" \
        --shortname="${MOODLE_SITESHORT}" \
        --lang="${MOODLE_LANG}"
    echo "Admin account: ${MOODLE_ADMINUSR}/${MOODLE_ADMINPWD}"
    echo "first setup done."
fi

# Adjust dir permission
chown -R apache.apache /var/www/moodledata
chown -R apache.apache /var/www/localhost/htdocs/moodle

# Start httpd
mkdir -p /run/apache2
httpd -D FOREGROUND
