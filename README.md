# SUNET Nextcloud

## Prerequisits

### Docker

    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker ubuntu

Remember to log out and back in for this to take effect!

Installation instructions: https://docs.docker.com/engine/install/ubuntu/

### Docker Compose

    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

Installation instructions: https://docs.docker.com/compose/install/

### s3cmd

    sudo apt install s3cmd

## Nextcloud Global Site Selector and Nextcloud node

### Building Docker image

    docker build -t jakubkrzywda/nextcloud:apache .

TODO: Add notes regarding S3 and GSS configuration (envsubst and occ).

### Deploying Nextcloud application

#### Configure

Set values in

- nextcloud.env
- db.env
- redis.env
- s3.env

based on *.env_template files.

#### Create S3 bucket

If S3 is used as a primary storage, create the bucket before deploying the application 

    s3cmd mb s3://[BUCKET_NAME]

#### Deploy

    docker-compose up -d

### Administration

Admin login to Global Site Selector: https://gss.nextcloud.dev.services.safedc.net/

Admin login to the Nextcloud node: https://dc2.nextcloud.dev.services.safedc.net/index.php/login?direct=1

### Destroying the deployment

    docker-compose down

    docker volume prune

Warning: do not repeat too often in case of Let's Encrypt, otherwise you might hit a limit on [Certificates per Registered Domain (50 per week)](https://letsencrypt.org/docs/rate-limits/).

### Debugging

#### Docker logs

    docker logs nextcloud_app_1

#### App logs

    docker exec -it nextcloud_app_1 tail data/nextcloud.log

    sudo tail /var/lib/docker/volumes/nextcloud_nextcloud/_data/data/nextcloud.log

#### occ command

https://docs.nextcloud.com/server/13.0.0/admin_manual/configuration_server/occ_command.html

    docker exec -u www-data -it nextcloud_app_1 bash

    php occ ...

#### S3 bucket

Create .s3cfg

    [default]
    host_base = ...
    host_bucket = ...
    access_key = ...
    secret_key = ...
    use_https = True

Empty the bucket

    s3cmd rm s3://[BUCKET_NAME] --recursive --force

### Redeploy Nextcloud cluster

    docker rm -f nextcloud_app_1 nextcloud_cron_1 nextcloud_db_1 nextcloud_redis_1 nextcloud_proxy_1
    docker volume prune -f
    s3cmd rm s3://dc1-nextcloud-bucket --recursive --force
    docker build --no-cache -t jakubkrzywda/nextcloud:apache .

    docker-compose up -d

## Lookup server

Check `lookup-server` directory.
