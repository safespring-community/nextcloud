ARG NEXTCLOUD_BASE_IMAGE=nextcloud:19.0-apache
FROM ${NEXTCLOUD_BASE_IMAGE}

# install envsubst required for S3 configuration
RUN apt-get update && apt-get install -y gettext-base
COPY --chown=www-data:www-data ./s3.config.template /var/www/html/config/

COPY --chown=www-data:www-data ./gss_config.sh /
COPY --chown=www-data:www-data ./mail_config.sh /
COPY --chown=root:root ./extended_entrypoint.sh /
ENTRYPOINT ["/extended_entrypoint.sh"]
CMD ["apache2-foreground"]
