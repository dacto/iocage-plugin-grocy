#!/bin/sh

# Download grocy
GROCY_VERSION="2.7.1"
WEBROOT="/usr/local/www/grocy"
GROCY_SRC="${WEBROOT}/grocy_${GROCY_VERSION}.zip"

mkdir -p "$WEBROOT"
curl -s -L -o "$GROCY_SRC" "https://github.com/grocy/grocy/releases/download/v${GROCY_VERSION}/grocy_${GROCY_VERSION}.zip"
unzip -q -d "$WEBROOT" "$GROCY_SRC"
rm -f "$GROCY_SRC"

mkdir -p "${WEBROOT}/data/settingoverrides"
cp "${WEBROOT}/config-dist.php" "${WEBROOT}/data/config.php"
chown -R www:www "$WEBROOT"
chmod -R o-rwx "$WEBROOT"
chmod -R g-wx "$WEBROOT"
chmod -R a-w "$WEBROOT"
chmod -R a+w "$WEBROOT/data"

# Configure PHP
PHP_MEMORY_LIMIT="512M"
PHP_MAX_UPLOAD="50M"
PHP_MAX_FILE_UPLOAD="200"
PHP_MAX_POST="100M"
PHP_DISPLAY_ERRORS="On"
PHP_DISPLAY_STARTUP_ERRORS="On"
PHP_ERROR_REPORTING="E_COMPILE_ERROR|E_RECOVERABLE_ERROR|E_ERROR|E_CORE_ERROR"

sed -E \
    -e "s/(display_errors =).*/\1 ${PHP_DISPLAY_ERRORS}/" \
    -e "s/(display_startup_errors =).*/\1 ${PHP_DISPLAY_STARTUP_ERRORS}/" \
    -e "s/(error_reporting =).*/\1 ${PHP_ERROR_REPORTING}/" \
    -e "s/;*(memory_limit =).*/\1 ${PHP_MEMORY_LIMIT}/" \
    -e "s/;*(upload_max_filesize =).*/\1 ${PHP_MAX_UPLOAD}/" \
    -e "s/;*(max_file_uploads =).*/\1 ${PHP_MAX_FILE_UPLOAD}/" \
    -e "s/;*(post_max_size =).*/\1 ${PHP_MAX_POST}/" \
    /usr/local/etc/php.ini-production > /usr/local/etc/php.ini

# Enable the services
sysrc -f /etc/rc.conf nginx_enable="YES" 2>/dev/null
sysrc -f /etc/rc.conf php_fpm_enable="YES" 2>/dev/null

# Start the services
service php-fpm start 2>/dev/null
service nginx start 2>/dev/null

echo "Default Admin Username: admin" > /root/PLUGIN_INFO
echo "Default Admin Password: admin" >> /root/PLUGIN_INFO
cat /root/PLUGIN_INFO
