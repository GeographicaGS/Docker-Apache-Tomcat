# Custom configuration
# This is for a little GeoServer on a testing virtual machine.
# Has the option to use JMX to monitor the JVM.

export LD_LIBRARY_PATH=/usr/local/lib:$CATALINA_HOME/lib:$LD_LIBRARY_PATH
export JAVA_HOME=/usr/local/jdk1.7.0_75/
export JRE_HOME=/usr/local/jdk1.7.0_75/jre

JMX_PORT=3333
JMX_ACCESS_FILE=$JMX_CONF_FOLDER/jmxremote.access
JMX_PASSWORD_FILE=$JMX_CONF_FOLDER/jmxremote.password

CATALINA_OPTS="-server -d64 -XX:+AggressiveOpts -Djava.library.path=/usr/local/apache-tomcat-8.0.18/lib:/usr/local/lib -Djava.awt.headless=true -XX:MaxGCPauseMillis=500 -Xmx${MEM} -Xms${MEM} -Xincgc"

if $JMX ; then
    CATALINA_OPTS="${CATALINA_OPTS} -Dcom.sun.management.access.file=${JMX_ACCESS_FILE} -Dcom.sun.management.jmxremote.password.file=${JMX_PASSWORD_FILE} -Dcom.sun.management.jmxremote.authenticate=true -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.port=${JMX_PORT} -Djava.rmi.server.hostname=${JMX_HOSTNAME}"
fi
