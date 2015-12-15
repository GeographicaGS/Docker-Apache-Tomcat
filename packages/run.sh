#!/bin/bash

exec gosu tomcat $CATALINA_HOME/bin/catalina.sh run
