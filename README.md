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

### Deploying Nextcloud application

#### Configure

Set values in

- nextcloud.env
- db.env
- redis.env
- gss.env
- s3.env
- mail.env

based on *.env_template files.

Note that even when configuration options are not needed in a particular deployment all of the .env files listed above have to exist.

#### Deploy

Use `redeploy.sh` script to build docker images and deploy the complete solution

    ./redeploy.sh

### Administration

For the admin login to Global Site Selector use https://gss.dev.nextcloud.safedc.services/

For the admin login to the Nextcloud Server use `index.php/login?direct=1` suffix, for example: https://nx0.dev.nextcloud.safedc.services/index.php/login?direct=1

### Redeploy

Use `redeploy.sh` script to redeploy the solution (except the Let's Encrypt container)

    ./redeploy.sh

`-e` - erase the primary S3 bucket

`-p` - prune docker volumes (except the one with SSL certificates)

### Destroying the deployment

    docker-compose down

    docker volume prune

Warning: do not prune the Let's Encrypt volumes too often, otherwise you might hit a limit on [Certificates per Registered Domain (50 per week)](https://letsencrypt.org/docs/rate-limits/).

### Upgrade Nextcloud version

To upgrade the version of Nextcloud in use:

1. In `nextcloud.env` file, modify the value of `NEXTCLOUD_VERSION` and set it to a valid tag of Nextcloud's official docker images. You can find a list of tags [here](https://hub.docker.com/_/nextcloud/?tab=tags).

2. Redeploy the environment using `redeploy.sh` script.

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
