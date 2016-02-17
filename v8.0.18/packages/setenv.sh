# Custom configuration

CATALINA_OPTS="-server -d64 -XX:+AggressiveOpts -XX:MaxPermSize=${MAXPERMSIZE} -Djava.library.path=/usr/local/apache-tomcat-8.0.18/lib:/usr/local/lib -Djava.awt.headless=true -XX:MaxGCPauseMillis=500 -Xmx${XMX} -Xms${XMS} -Xincgc"

if $JMX ; then
    CATALINA_OPTS="${CATALINA_OPTS} -Dcom.sun.management.access.file=${JMX_ACCESS_FILE} -Dcom.sun.management.jmxremote.password.file=${JMX_PASSWORD_FILE} -Dcom.sun.management.jmxremote.authenticate=false -Xdebug -Xrunjdwp:transport=dt_socket,address=62911,server=y,suspend=n -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.port=${JMX_PORT} -Djava.rmi.server.hostname=${JMX_HOSTNAME} -Dcom.sun.management.jmxremote.rmi.port=${JMX_PORT}"
fi

if $PROXY ; then
    CATALINA_OPTS="${CATALINA_OPTS} -Dhttp.proxyHost=${PROXYNAME} -Dhttp.proxyPort=${PROXYPORT}"
fi
