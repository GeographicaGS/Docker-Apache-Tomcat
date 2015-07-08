# Version: 0.0.1
FROM geographica/java_virtual_machine:server_jre_7u75_x64

MAINTAINER Juan Pedro Perez "jp.alcantara@geographica.gs"

ENV JAVA_HOME /usr/local/jdk1.7.0_75
ENV JRE_HOME /usr/local/jdk1.7.0_75/jre
ENV ANT_HOME /usr/local/apache-ant-1.9.4
ENV CATALINA_HOME /usr/local/apache-tomcat-8.0.18
ENV PATH $JAVA_HOME/bin:$JRE_HOME/bin:$ANT_HOME/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/lib:$CATALINA_HOME/lib:$LD_LIBRARY_PATH
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

# Add all packages
ADD packages/apache-ant-1.9.4-bin.tar.bz2 /usr/local
ADD packages/apache-tomcat-8.0.18.tar.gz /usr/local
ADD packages/apr-1.5.1.tar.gz /usr/local
ADD packages/setenv.sh $CATALINA_HOME/bin/
ADD packages/jmxremote.* $CATALINA_HOME/conf/
ADD packages/compile.sh /usr/local/

# Do everything
WORKDIR /usr/local/
RUN chmod 777 compile.sh
RUN ./compile.sh

EXPOSE 8080
EXPOSE 3333
EXPOSE 62911
CMD su tomcat -s /bin/bash -c "$CATALINA_HOME/bin/catalina.sh run"
