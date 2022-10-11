#!/usr/bin/env sh
# ----------------------------------------------------------------------------
#  Copyright 2001-2006 The Apache Software Foundation.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------
#
#   Copyright (c) 2001-2006 The Apache Software Foundation.  All rights
#   reserved.


# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

PRGDIR=`dirname "$PRG"`
BASEDIR=`cd "$PRGDIR/.." >/dev/null; pwd`

# Reset the REPO variable. If you need to influence this use the environment setup file.
REPO=


# OS specific support.  $var _must_ be set to either true or false.
cygwin=false;
darwin=false;
case "`uname`" in
  CYGWIN*) cygwin=true ;;
  Darwin*) darwin=true
           if [ -z "$JAVA_VERSION" ] ; then
             JAVA_VERSION="CurrentJDK"
           else
             echo "Using Java version: $JAVA_VERSION"
           fi
		   if [ -z "$JAVA_HOME" ]; then
		      if [ -x "/usr/libexec/java_home" ]; then
			      JAVA_HOME=`/usr/libexec/java_home`
			  else
			      JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/${JAVA_VERSION}/Home
			  fi
           fi       
           ;;
esac

if [ -z "$JAVA_HOME" ] ; then
  if [ -r /etc/gentoo-release ] ; then
    JAVA_HOME=`java-config --jre-home`
  fi
fi

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin ; then
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --unix "$CLASSPATH"`
fi

# If a specific java binary isn't specified search for the standard 'java' binary
if [ -z "$JAVACMD" ] ; then
  if [ -n "$JAVA_HOME"  ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
      # IBM's JDK on AIX uses strange locations for the executables
      JAVACMD="$JAVA_HOME/jre/sh/java"
    else
      JAVACMD="$JAVA_HOME/bin/java"
    fi
  else
    JAVACMD=`which java`
  fi
fi

if [ ! -x "$JAVACMD" ] ; then
  echo "Error: JAVA_HOME is not defined correctly." 1>&2
  echo "  We cannot execute $JAVACMD" 1>&2
  exit 1
fi

if [ -z "$REPO" ]
then
  REPO="$BASEDIR"/lib
fi

#CLASSPATH="$BASEDIR"/conf:"$REPO"/iiot.protocol-1.3.jar:"$REPO"/hamcrest-core-1.3.jar:"$REPO"/service-rpc-0.13.2.jar:"$REPO"/iotdb-thrift-0.13.2.jar:"$REPO"/snappy-java-1.1.8.4.jar:"$REPO"/tsfile-0.13.2.jar:"$REPO"/lz4-java-1.8.0.jar:"$REPO"/libthrift-0.14.1.jar:"$REPO"/influxdb-thrift-0.13.2.jar:"$REPO"/jjwt-api-0.10.7.jar:"$REPO"/jjwt-impl-0.10.8.jar:"$REPO"/jjwt-jackson-0.10.7.jar:"$REPO"/json-smart-2.3.jar:"$REPO"/accessors-smart-1.2.jar:"$REPO"/asm-5.0.4.jar:"$REPO"/gson-2.8.8.jar:"$REPO"/logback-classic-1.2.10.jar:"$REPO"/logback-core-1.2.10.jar:"$REPO"/slf4j-api-1.7.32.jar:"$REPO"/javax.annotation-api-1.3.2.jar:"$REPO"/jaxb-api-2.4.0-b180830.0359.jar:"$REPO"/javax.activation-api-1.2.0.jar:"$REPO"/jaxb-runtime-3.0.2.jar:"$REPO"/jakarta.activation-2.0.1.jar:"$REPO"/jaxb-core-3.0.2.jar:"$REPO"/jakarta.xml.bind-api-3.0.1.jar:"$REPO"/txw2-3.0.2.jar:"$REPO"/istack-commons-runtime-4.0.1.jar:"$REPO"/jackson-databind-2.9.5.jar:"$REPO"/jackson-annotations-2.9.0.jar:"$REPO"/jackson-core-2.9.5.jar:"$REPO"/iotdb-session-0.13.2.jar:"$REPO"/commons-io-2.11.0.jar:"$REPO"/fastjson-1.2.73.jar:"$REPO"/commons-lang3-3.12.0.jar:"$REPO"/spring-web-5.1.8.RELEASE.jar:"$REPO"/spring-beans-5.1.8.RELEASE.jar:"$REPO"/spring-core-5.1.8.RELEASE.jar:"$REPO"/spring-jcl-5.1.8.RELEASE.jar:"$REPO"/spring-boot-autoconfigure-1.5.15.RELEASE.jar:"$REPO"/spring-boot-1.5.15.RELEASE.jar:"$REPO"/spring-context-4.3.18.RELEASE.jar:"$REPO"/spring-boot-starter-web-1.5.15.RELEASE.jar:"$REPO"/spring-boot-starter-1.5.15.RELEASE.jar:"$REPO"/spring-boot-starter-logging-1.5.15.RELEASE.jar:"$REPO"/jcl-over-slf4j-1.7.25.jar:"$REPO"/jul-to-slf4j-1.7.25.jar:"$REPO"/log4j-over-slf4j-1.7.25.jar:"$REPO"/spring-boot-starter-tomcat-1.5.15.RELEASE.jar:"$REPO"/tomcat-embed-core-8.5.32.jar:"$REPO"/tomcat-annotations-api-8.5.32.jar:"$REPO"/tomcat-embed-el-8.5.32.jar:"$REPO"/tomcat-embed-websocket-8.5.32.jar:"$REPO"/hibernate-validator-5.3.6.Final.jar:"$REPO"/validation-api-1.1.0.Final.jar:"$REPO"/jboss-logging-3.3.0.Final.jar:"$REPO"/classmate-1.3.1.jar:"$REPO"/spring-webmvc-4.3.18.RELEASE.jar:"$REPO"/spring-aop-4.3.18.RELEASE.jar:"$REPO"/spring-expression-4.3.18.RELEASE.jar:"$REPO"/spring-boot-configuration-processor-2.1.6.RELEASE.jar:"$REPO"/sureness-core-0.4.3.jar:"$REPO"/snakeyaml-1.17.jar:"$REPO"/spring-boot-starter-test-1.5.15.RELEASE.jar:"$REPO"/spring-boot-test-1.5.15.RELEASE.jar:"$REPO"/spring-boot-test-autoconfigure-1.5.15.RELEASE.jar:"$REPO"/json-path-2.2.0.jar:"$REPO"/assertj-core-2.6.0.jar:"$REPO"/mockito-core-1.10.19.jar:"$REPO"/objenesis-2.1.jar:"$REPO"/hamcrest-library-1.3.jar:"$REPO"/jsonassert-1.4.0.jar:"$REPO"/android-json-0.0.20131108.vaadin1.jar:"$REPO"/spring-test-4.3.18.RELEASE.jar:"$REPO"/moshi-1.8.0.jar:"$REPO"/okio-1.16.0.jar:"$REPO"/frame_protocol-1.0-SNAPSHOT.jar


CLASSPATH="$BASEDIR"/conf
for f in "$REPO"/*.jar; do
  CLASSPATH=${CLASSPATH}":"$f
done

ENDORSED_DIR=
if [ -n "$ENDORSED_DIR" ] ; then
  CLASSPATH=$BASEDIR/$ENDORSED_DIR/*:$CLASSPATH
fi

if [ -n "$CLASSPATH_PREFIX" ] ; then
  CLASSPATH=$CLASSPATH_PREFIX:$CLASSPATH
fi

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --windows "$CLASSPATH"`
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
  [ -n "$HOME" ] && HOME=`cygpath --path --windows "$HOME"`
  [ -n "$BASEDIR" ] && BASEDIR=`cygpath --path --windows "$BASEDIR"`
  [ -n "$REPO" ] && REPO=`cygpath --path --windows "$REPO"`
fi

exec "$JAVACMD" $JAVA_OPTS  \
  -classpath "$CLASSPATH" \
  -Dapp.name="start" \
  -Dapp.pid="$$" \
  -Dapp.repo="$REPO" \
  -Dapp.home="$BASEDIR" \
  -Dbasedir="$BASEDIR" \
  com.timecho.MakeData \
  "$@"
