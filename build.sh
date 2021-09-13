#!/bin/bash

set -e

AMQP_VERSION=${AMQP_VERSION:-"$(curl -Is https://pecl.php.net/get/amqp | grep filename | sed 's/.*\([[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+.*\.\).*/\1/;s/.$//g')"}
#curl -Is https://pecl.php.net/get/amqp | grep filename | curl -Is https://pecl.php.net/get/amqp | grep filename | sed 's/.*\([[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\).*/\1/')"}
PSR_VERSION=${PSR_VERSION:-"$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --sort='version:refname' --tags https://github.com/jbboehr/php-psr.git '*.*.*' | tail --lines=1 | cut --delimiter='/' --fields=3 | sed 's/^v//g')"}
PHP_VERSIONS=${PHP_VERSIONS:-"7.3,7.4"}
NEWRELIC_VERSION=${NEWRELIC_VERSION:-"5-9.17.1.301"}
getlatesttag() {
  MAJORMINOR=${1:-"7.4"}
  wget -q https://registry.hub.docker.com/v1/repositories/php/tags -O - | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep -e "^${MAJORMINOR}.[0-9]\+$" | sort -n | tail -1
}

buildall() {
  echo "AMQP_VERSION: "$AMQP_VERSION
  echo "PSR_VERSION: "$PSR_VERSION

  DOCKERFILEPATH=${1:-"Dockerfile"}
  IMAGESUFFIX=${2:-"-alpine"}

  IFS=, read -a versions <<< ${PHP_VERSIONS}
  for MAJORMINOR in "${versions[@]}"; do
     for c in `seq 1 2`; do
       MAJORMINORBILD=$(getlatesttag ${MAJORMINOR})
       MAJOR=$(echo $MAJORMINOR | awk -F '.' '{print $1}')
       echo "=== BUILD DOCKERFILE: ${1}, PHP: ${MAJORMINORBILD}-${2}, COMPOSER: ${c}"
       docker build \
         --build-arg IMAGE_VERSION=${MAJORMINORBILD}-${2} \
         --build-arg AMQP_VERSION=${AMQP_VERSION} \
         --build-arg PSR_VERSION=${PSR_VERSION} \
         --build-arg COMPOSER_MAJOR=${c} \
         -t akel/php:${MAJORMINORBILD}-${2}-comp${c} \
         -t akel/php:${MAJORMINORBILD}-${2} \
         -t akel/php:${MAJORMINOR}-${2}-comp${c} \
         -t akel/php:${MAJORMINOR}-${2} \
         -t akel/php:${MAJOR}-${2}-comp${c} \
         -t akel/php:${MAJOR}-${2} \
         -t akel/php:${MAJOR}-comp${c} \
         -t akel/php:${MAJOR} \
         -t akel/php:${2}-comp${c} \
         -t akel/php:${2} \
         -t akel/php \
         -f ${1} .
     done
  done
}

buildall Dockerfile-fpm "fpm-alpine"
buildall Dockerfile-cli "alpine"
