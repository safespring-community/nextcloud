FROM nextcloud:apache
COPY --chown=www-data:www-data ./s3.config.php /var/www/html/config/
