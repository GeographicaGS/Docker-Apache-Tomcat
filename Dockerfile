# Version: 0.0.1
FROM geographica/java_virtual_machine:server_jre_7u75_x64

MAINTAINER Juan Pedro Perez "jp.alcantara@geographica.gs"

# This is a clever instruction, for, if changed, will force the build command to
# skip cache and recreate the whole image from scratch
ENV REFRESHED_AT 2015-04-06
ENV JAVA_HOME /usr/local/jdk1.7.0_75
ENV JRE_HOME /usr/local/jdk1.7.0_75/jre
ENV ANT_HOME /usr/local/apache-ant-1.9.4
ENV CATALINA_HOME /usr/local/apache-tomcat-8.0.18
ENV PATH $JAVA_HOME/bin:$JRE_HOME/bin:$ANT_HOME/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/lib
ENV JMX false
ENV JMX_HOSTNAME 127.0.0.1
ENV JMX_CONF_FOLDER $CATALINA_HOME/conf
ENV MEM 64m
ENV MMEM 64m
ENV PMEM 512k


# Some dependencies to have a build chaintool
RUN apt-get update && apt-get install -y build-essential libssl-dev


# Install Apache Ant
ADD packages/apache-ant-1.9.4-bin.tar.bz2 /usr/local
WORKDIR /usr/local/apache-ant-1.9.4
RUN ant -f fetch.xml -Ddest=system


# Install Apache Tomcat 8.0.18 to /usr/local
ADD packages/apache-tomcat-8.0.18.tar.gz /usr/local
# RUN groupadd tomcat && useradd -r -s /sbin/nologin -g tomcat -d /usr/local/apache-tomcat-8.0.18/ tomcat && echo "tomcat:tomcat" | chpasswd


# Install the Native Tomcat Apache Portable Runtime
RUN mkdir -p /usr/local/src/
ADD packages/apr-1.5.1.tar.gz /usr/local/src
WORKDIR /usr/local/src/apr-1.5.1
RUN ./configure --prefix=/usr/local && make && make install && ldconfig && rm -Rf /usr/local/src


# Enable APR in Tomcat
WORKDIR /usr/local/apache-tomcat-8.0.18/bin
RUN tar -xzvf tomcat-native.tar.gz
WORKDIR /usr/local/apache-tomcat-8.0.18/bin/tomcat-native-1.1.32-src/jni
RUN ant
WORKDIR /usr/local/apache-tomcat-8.0.18/bin/tomcat-native-1.1.32-src/jni/native
RUN ./configure --with-apr=/usr/local --with-java-home=$JAVA_HOME --with-ssl=/usr/local --prefix=$CATALINA_HOME && make && make install && ldconfig

# && chown -R tomcat:tomcat /usr/local/apache-tomcat-8.0.18 && chmod 770 -R /usr/local/apache-tomcat-8.0.18/webapps 


# Install Tomcat environment options
WORKDIR /usr/local/apache-tomcat-8.0.18/
ADD packages/setenv.sh bin/


# Drop the /usr/local/src folder
RUN rm -Rf /usr/local/src


# Add JMX configuration
ADD packages/jmxremote.* $CATALINA_HOME/conf/
RUN chmod 600 $JMX_CONF_FOLDER/jmxremote.*

# && chown tomcat:tomcat $JMX_CONF_FOLDER/jmxremote.*


EXPOSE 8080
EXPOSE 3333
CMD $CATALINA_HOME/bin/catalina.sh run
