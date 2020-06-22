# moodle-docker-production: Docker Containers for Moodle

This repository contains Docker configuration aimed to provide a good starting point to install moodle in production using docker.

In Catedu we need to deploy several hundreds of Moodle. This repo aims to give us a solution to test locally our developments and to generate our docker images. Our final solution is being implemented in [moodle-docker-deploy repo](https://github.com/catedu/moodle-docker-deploy).


## Features

* Database servers: MySQL / MariaDB /PostGreSQL (MySQL in this repo)
* Last supported PHP version
* Zero-configuration approach
* All php-extensions (thanks to [moodlehq](https://github.com/moodlehq/moodle-php-apache))


## Missing Features

These features are out of the scope of this repo (you may have a look at [moodle-docker-deploy repo](https://github.com/catedu/moodle-docker-deploy)):

* Crontab configuration
* Auto backup 


## Prerequisites

* [Docker](https://docs.docker.com) and [Docker Compose](https://docs.docker.com/compose/) installed


## Quick start


```
cp env-sample .env
docker-compose up -d
```

Open browser webpage: http://localhost (be patient)


## Configuration

* Configure your moodle installation using an .env file
* We have two environments: production (https ready with letsencrypt) and development (default).

* Plugins or special configuration is done using shell scripts or php files. The moodle container executes them from init-scripts directory. We provide an example script (plugins-sampe.sh) file, and moodle image has [moosh binary](https://moosh-online.com/).


## Activate https

- Using [letsEncrypt](https://letsencrypt.org/), activating production environment:

  ```
  cp docker-compose.override_prod.yml docker-compose.override.yml
  docker-compose up -d
  ```
- Modify .env file

  ```
  MOODLE_URL=https://localhost
  SSL_PROXY=true
  ```

## Contributions

Are extremely welcome!

## After installing. TODOs via web interface

* Need to register the site in yout-moodle-url/admin/registration/index.php?returnurl=%2Fadmin%2Findex.php
* Need to enable mobile messages in your-moodle-url/admin/message.php
* Need to requests an airnotifierkey in your-moodle-url/admin/settings.php?section=messagesettingairnotifier
* Need to enable notifications through mobile in your-moodle-url/admin/message.php
* Need to install H5P Modules through web interface by adding an H5P activity to a course and, then, install all the modules
* Need to upload users
* Need to configure caché through your-moodle-url/cache/admin.php
* Need to configure frontpage _nothing_ and frontpageloggedin _Cursos inscritos_, _Mostrar items de noticias_, nothing else in your-moodle-url/admin/settings.php?section=frontpagesettings
* Need to add Policies and agreements in your-moodle-url/admin/tool/policy/managedocs.php?archived=0 as it is in moodle-model/admin/tool/policy/managedocs.php?archived=0
