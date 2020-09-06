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

For the admin login to Global Site Selector use https://gss.dev.nextcloud.safedc.services/

For the admin login to the Nextcloud Server use `index.php/login?direct=1` suffix, for example: https://nx0.dev.nextcloud.safedc.services/index.php/login?direct=1

### Destroying the deployment

    docker-compose down

    docker volume prune

Warning: do not redeploy the whole system too often in case when Let's Encrypt is used, otherwise you might hit a limit on [Certificates per Registered Domain (50 per week)](https://letsencrypt.org/docs/rate-limits/).

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

Create a bucket

    s3cmd mb s3://[BUCKET_NAME]

Empty the bucket

    s3cmd rm s3://[BUCKET_NAME] --recursive --force

Remove the bucket

    s3cmd rb s3://[BUCKET_NAME]

### Redeploy Nextcloud Server

    ./redeploy.sh
