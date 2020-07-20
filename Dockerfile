FROM nextcloud:apache
COPY --chown=www-data:www-data ./s3.config.php /var/www/html/config/
COPY --chown=www-data:www-data ./gss_config.sh /
COPY --chown=root:root ./extended_entrypoint.sh /
ENTRYPOINT ["/extended_entrypoint.sh"]
CMD ["apache2-foreground"]
