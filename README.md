Docker Image for Apache Tomcat
==============================

This is the README.md for Docker tag __v8.0.18__. Please refer to the __Master__ README.md for updated information.

What does this Docker image contains?
-------------------------------------
The following:

- Apache Tomcat as provided by the Apache Foundation (not from packages);

- the Apache Portable Runtime, compiled from source, and enabled into Tomcat.

Check _Tags_ for version info.


Versions
--------
Different versions may be available in the future. By now:

- __v8.0.18:__ Oracle Java Virtual Machine Server JDK 1.7.0-75, Apache Ant 1.9.4, Apache Tomcat 8.0.18, and Apache Portable Runtime 1.5.1.

Guidelines for Creating New Docker Tags in this Repository
----------------------------------------------------------
Each Docker tag in this repository addresses changes in library versions bundled together. Follow this guidelines when creating new Docker tags for this repo:

- to create and maintain new Docker tags, make a GIT branch with a descriptive name. Each tag must match its branch in name. Do not use GIT tags to support Docker tags, for branches does exactly the same job and does it better in this case. Never destroy those branches and keep them open;

- the master branch should reflect the most updated README.md. This means that the master branch may not point to the most "advanced" branch in terms of library versions. But always refer to the master README.md for the most updated information;

- don't forget to document detailed information about the new GIT branch / Docker tag in the former section;

- don't forget to update the first line of this README.md warning about the README.md version to tell the user about the README.md being read.

Usage Pattern
-------------
Build the image directly from GitHub (this can take a while):

```Shell
git checkout tagbranch

docker build -t="geographica/apache-tomcat:v8.0.18" .
```

or pull it from Docker Hub:

```Shell
docker pull geographica/apache-tomcat:v8.0.18
```

To start the container interactively:

```Shell
docker run -ti -p 8080:8080 --name whatever geographica/apache-tomcat:v8.0.18 /bin/bash
```

or, if JMX is wanted (by default, JMX is deactivated):

```Shell
docker run -ti -p 8080:8080 -p 3333:3333 -p 62911:62911 -e "JMX=true" --name whatever geographica/apache-tomcat:v8.0.18
```

Tomcat's output can be seen and it can be closed with CTRL-C.

See all important environmental variables affecting the virtual machine in the __Dockerfile__. They can be overriden at container's creation. For example:

```Shell
docker run --rm -ti -p 8080:8080 -p 3333:3333 -p 62911:62911 -e "JMX=true" -e "XMX=256m" -e "XMS=256m" -e "MAXPERMSIZE=1024k" geographica/apache-tomcat:v8.0.18
```

In normal conditions, run the container this way:

```Shell
docker run -d -P --name whatever geographica/apache-tomcat:v8.0.18
```

JMX
---
JMX access control are based on __packages/jmxremote.*__. They are copied to __$JAVA_HOME__. Alter them before __docker build__ or enter into the container and change them manually to change permissions.
