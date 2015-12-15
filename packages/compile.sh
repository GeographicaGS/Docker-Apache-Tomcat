#!/bin/bash

# Update and download basic packages
apt-get update && apt-get install -y build-essential libssl-dev locales

# Install Apache Ant
cd apache-ant-1.9.4 ; ant -f fetch.xml -Ddest=system ; cd ..

# Add user and group
groupadd tomcat
useradd -r -s /sbin/nologin -g tomcat -d /usr/local/apache-tomcat-8.0.18/ tomcat
echo "tomcat:tomcat" | chpasswd

# Install Apache Portable Runtime
cd apr-1.5.1 ; ./configure --prefix=/usr/local ; cd ..
cd apr-1.5.1 ; make ; cd ..
cd apr-1.5.1 ; make install ; cd ..
ldconfig

# Install Tomcat Native
tar -xzvf $CATALINA_HOME/bin/tomcat-native.tar.gz -C $CATALINA_HOME/bin/
cd $CATALINA_HOME/bin/tomcat-native-1.1.32-src/jni/ ; ant ; cd ..
cd $CATALINA_HOME/bin/tomcat-native-1.1.32-src/jni/native/ ; ./configure --with-apr=/usr/local --with-java-home=$JAVA_HOME --with-ssl=/usr/local --prefix=$CATALINA_HOME ; cd ..
cd $CATALINA_HOME/bin/tomcat-native-1.1.32-src/jni/native/ ; make ; cd ..
cd $CATALINA_HOME/bin/tomcat-native-1.1.32-src/jni/native/ ; make install ; cd ..
ldconfig

# Configuration of JMX
chown -R tomcat:tomcat $CATALINA_HOME
chmod 770 -R $CATALINA_HOME/webapps
chmod 600 $JMX_CONF_FOLDER/jmxremote.*
chown tomcat:tomcat $JMX_CONF_FOLDER/jmxremote.*

# Cleanup
rm -Rf /usr/local/apache-ant-1.9.4
rm -Rf /usr/local/apr-1.5.1
rm -Rf /usr/local/bin/compile.sh

# Define locals
IFS=',' read -r -a array <<< $GENERATELOCALE

for i in "${array[@]}"
do
    locale-gen $i
done;

locale-gen

