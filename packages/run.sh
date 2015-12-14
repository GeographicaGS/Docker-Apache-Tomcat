#!/bin/bash
# set -e

TLOCALE=es_ES.UTF-8
GENERATELOCALE="es_ES.UTF-8,es_ES ISO-8859-1"

# Check if locale is set

if ! [ "$(locale | grep LANG=)" == "LANG=$TLOCALE" ]; then
    IFS=',' read -r -a array <<< $GENERATELOCALE

    for i in "${array[@]}"
    do
	locale-gen $i
    done;

    locale-gen

    echo LANG=$TLOCALE >> /etc/default/locale
fi
