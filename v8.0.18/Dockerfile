FROM geographica/java_virtual_machine:server_jre_7u75_x64
MAINTAINER Juan Pedro Perez "jp.alcantara@geographica.gs"

ENV ANT_HOME /usr/local/apache-ant-1.9.4
ENV CATALINA_HOME /usr/local/apache-tomcat-8.0.18
ENV PATH $ANT_HOME/bin:$PATH
ENV LD_LIBRARY_PATH $CATALINA_HOME/lib:$LD_LIBRARY_PATH

# To use JMX or not
ENV JMX false

# JMX port
ENV JMX_PORT 3333
ENV JMX_HOSTNAME localhost
ENV JMX_CONF_FOLDER $CATALINA_HOME/conf

# JMX access file
ENV JMX_ACCESS_FILE $JMX_CONF_FOLDER/jmxremote.access

# JMX password file
ENV JMX_PASSWORD_FILE $JMX_CONF_FOLDER/jmxremote.password

# Max heap size
ENV XMX 64m

# Initial heap size
ENV XMS 64m

# PermSize size
ENV MAXPERMSIZE 64m

# Locale
ENV GENERATELOCALE="es_ES.UTF-8,es_ES.ISO-8859-1"
ENV TLOCALE=es_ES.utf8
ENV LANG=$TLOCALE
ENV LANGUAGE es_ES:es
ENV LC_ALL $TLOCALE

# Add all packages
ADD packages/apache-ant-1.9.4-bin.tar.bz2 /usr/local
ADD packages/apache-tomcat-8.0.18.tar.gz /usr/local
ADD packages/apr-1.5.1.tar.gz /usr/local
ADD packages/compile.sh /usr/local/bin/
ADD packages/gosu-amd64 /usr/local/bin/gosu
ADD packages/jmxremote.* $CATALINA_HOME/conf/
ADD packages/run.sh /usr/local/bin/
ADD packages/setenv.sh $CATALINA_HOME/bin/

# Do everything
WORKDIR /usr/local/bin
RUN chmod 777 compile.sh
RUN chmod 777 run.sh
RUN ./compile.sh

VOLUME $CATALINA_HOME/logs
VOLUME $CATALINA_HOME/webapps

EXPOSE 8080
EXPOSE 3333
EXPOSE 62911

ENTRYPOINT ["/usr/local/bin/run.sh"]
