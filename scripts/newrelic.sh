#!/bin/sh

if [ ! -z ${NEWRELIC_LICENSE+x} ] ; then
        echo "Newrelic php agent: Create configuration file"

        echo 'extension = "newrelic.so"' > ${PHP_INI_DIR}/conf.d/newrelic.ini
        echo 'newrelic.enabled = true' >> ${PHP_INI_DIR}/conf.d/newrelic.ini
        echo 'newrelic.license = "${NEWRELIC_LICENSE}"' >> ${PHP_INI_DIR}/conf.d/newrelic.ini
        echo 'newrelic.appname = "${NEWRELIC_APPNAME:-PHP Application}"' >> ${PHP_INI_DIR}/conf.d/newrelic.ini
        echo 'newrelic.daemon.address = "${NEWRELIC_DAEMON_ADDRESS:-/tmp/.newrelic.sock}"' >> ${PHP_INI_DIR}/conf.d/newrelic.ini

        echo "Newrelic php agent: Configuration file created. Location: ${PHP_INI_DIR}/conf.d/newrelic.ini"

        if [ ${RUN_NEWRELIC_DAEMON} = 'true' ]; then
           echo "Run newrelic daemon"
           /usr/bin/newrelic-daemon --logfile /proc/self/fd/1 --address=/tmp/.newrelic.sock
        fi
fi
