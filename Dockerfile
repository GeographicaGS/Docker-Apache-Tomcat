# Version: 0.0.1
FROM geographica/java_virtual_machine:server_jre_7u75_x64

MAINTAINER Juan Pedro Perez "jp.alcantara@geographica.gs"

ENV JAVA_HOME /usr/local/jdk1.7.0_75
ENV JRE_HOME /usr/local/jdk1.7.0_75/jre
ENV ANT_HOME /usr/local/apache-ant-1.9.4
ENV CATALINA_HOME /usr/local/apache-tomcat-8.0.18
ENV PATH $JAVA_HOME/bin:$JRE_HOME/bin:$ANT_HOME/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/lib:$CATALINA_HOME/lib:$LD_LIBRARY_PATH
ENV JMX true
ENV JMX_PORT 3333
ENV JMX_HOSTNAME localhost
ENV JMX_CONF_FOLDER $CATALINA_HOME/conf
ENV JMX_ACCESS_FILE $JMX_CONF_FOLDER/jmxremote.access
ENV JMX_PASSWORD_FILE $JMX_CONF_FOLDER/jmxremote.password
ENV MEM 64m
ENV MMEM 64m
ENV PMEM 512k


# Some dependencies to have a build chaintool
RUN apt-get update && apt-get install -y build-essential libssl-dev


# Add all packages
ADD packages/apache-ant-1.9.4-bin.tar.bz2 /usr/local
ADD packages/apache-tomcat-8.0.18.tar.gz /usr/local
ADD packages/apr-1.5.1.tar.gz /usr/local
ADD packages/setenv.sh $CATALINA_HOME/bin/
ADD packages/jmxremote.* $CATALINA_HOME/conf/

# WORKDIR /usr/local/apache-ant-1.9.4
# RUN ant -f fetch.xml -Ddest=system


# Install Apache Tomcat 8.0.18 to /usr/local
# ADD packages/apache-tomcat-8.0.18.tar.gz /usr/local
# RUN groupadd tomcat && useradd -r -s /sbin/nologin -g tomcat -d /usr/local/apache-tomcat-8.0.18/ tomcat && echo "tomcat:tomcat" | chpasswd


# Install the Native Tomcat Apache Portable Runtime
# RUN mkdir -p /usr/local/src/
# ADD packages/apr-1.5.1.tar.gz /usr/local/src
# WORKDIR /usr/local/src/apr-1.5.1
# RUN ./configure --prefix=/usr/local && make && make install && ldconfig && rm -Rf /usr/local/src


# Enable APR in Tomcat
# WORKDIR /usr/local/apache-tomcat-8.0.18/bin
# RUN tar -xzvf tomcat-native.tar.gz
# WORKDIR /usr/local/apache-tomcat-8.0.18/bin/tomcat-native-1.1.32-src/jni
# RUN ant
# WORKDIR /usr/local/apache-tomcat-8.0.18/bin/tomcat-native-1.1.32-src/jni/native
# RUN ./configure --with-apr=/usr/local --with-java-home=$JAVA_HOME --with-ssl=/usr/local --prefix=$CATALINA_HOME && make && make install && ldconfig

# && chown -R tomcat:tomcat /usr/local/apache-tomcat-8.0.18 && chmod 770 -R /usr/local/apache-tomcat-8.0.18/webapps 


# Install Tomcat environment options
# WORKDIR /usr/local/apache-tomcat-8.0.18/
# ADD packages/setenv.sh bin/


# Drop the /usr/local/src folder
# RUN rm -Rf /usr/local/src


# Add JMX configuration
# ADD packages/jmxremote.* $CATALINA_HOME/conf/
# RUN chmod 600 $JMX_CONF_FOLDER/jmxremote.*

# && chown tomcat:tomcat $JMX_CONF_FOLDER/jmxremote.*







# REWORKS HERE




WORKDIR /usr/local

RUN cd apache-ant-1.9.4 ; ant -f fetch.xml -Ddest=system ; cd .. && groupadd tomcat && useradd -r -s /sbin/nologin -g tomcat -d /usr/local/apache-tomcat-8.0.18/ tomcat && echo "tomcat:tomcat" | chpasswd && cd apr-1.5.1 ; ./configure --prefix=/usr/local ; cd .. && cd apr-1.5.1 ; make ; cd .. && cd apr-1.5.1 ; make install ; cd .. && ldconfig && tar -xzvf $CATALINA_HOME/bin/tomcat-native.tar.gz -C $CATALINA_HOME/bin/ && cd $CATALINA_HOME/bin/tomcat-native-1.1.32-src/jni/ ; ant ; cd .. && cd $CATALINA_HOME/bin/tomcat-native-1.1.32-src/jni/native/ ; ./configure --with-apr=/usr/local --with-java-home=$JAVA_HOME --with-ssl=/usr/local --prefix=$CATALINA_HOME ; cd .. && cd $CATALINA_HOME/bin/tomcat-native-1.1.32-src/jni/native/ ; make ; cd .. && cd $CATALINA_HOME/bin/tomcat-native-1.1.32-src/jni/native/ ; make install ; cd .. && ldconfig && chown -R tomcat:tomcat $CATALINA_HOME && chmod 770 -R $CATALINA_HOME/webapps && chmod 600 $JMX_CONF_FOLDER/jmxremote.* && chown tomcat:tomcat $JMX_CONF_FOLDER/jmxremote.* && rm -Rf apache-ant-1.9.4 && rm -Rf apr-1.5.1



EXPOSE 8080
EXPOSE 3333
EXPOSE 62911
CMD su tomcat -s /bin/bash -c "$CATALINA_HOME/bin/catalina.sh run"
