#!/bin/sh

if [ ! -z ${PHP_CRONTABS_PATH+x} ] && [ "$PHP_CRONTABS_PATH" != "" ]; then
        printf "env CRONTABS_PATH: setting up crontabs: ";

        for f in ${PHP_CRONTABS_PATH}; do
                printf "$f, ";
                rm -f /etc/crontabs/${f##*/}
                cp $f /etc/crontabs/
                chmod 0600 /etc/crontabs/${f##*/}
        done

        echo
        printenv | grep -v "no_proxy" >> /etc/environment

        if [ -z ${PHP_CRONTABS_LOGPATH+x} ]; then
           /usr/sbin/crond
        else
           /usr/sbin/crond > ${PHP_CRONTABS_LOGPATH}
        fi
fi
