@REM ----------------------------------------------------------------------------
@REM  Copyright 2001-2006 The Apache Software Foundation.
@REM
@REM  Licensed under the Apache License, Version 2.0 (the "License");
@REM  you may not use this file except in compliance with the License.
@REM  You may obtain a copy of the License at
@REM
@REM       http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM  Unless required by applicable law or agreed to in writing, software
@REM  distributed under the License is distributed on an "AS IS" BASIS,
@REM  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM  See the License for the specific language governing permissions and
@REM  limitations under the License.
@REM ----------------------------------------------------------------------------
@REM
@REM   Copyright (c) 2001-2006 The Apache Software Foundation.  All rights
@REM   reserved.

@echo off

set ERROR_CODE=0

:init
@REM Decide how to startup depending on the version of windows

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

@REM The 4NT Shell from jp software
:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of arguments (up to the command line limit, anyway).
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
%0\
cd %0\..\.. 
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
for %%i in ("%~dp0..") do set "BASEDIR=%%~fi"

:repoSetup
set REPO=


if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=%BASEDIR%\lib

@REM set CLASSPATH="%BASEDIR%"\conf;"%REPO%"\iiot.protocol-1.3.jar;"%REPO%"\hamcrest-core-1.3.jar;"%REPO%"\service-rpc-0.13.2.jar;"%REPO%"\iotdb-thrift-0.13.2.jar;"%REPO%"\snappy-java-1.1.8.4.jar;"%REPO%"\tsfile-0.13.2.jar;"%REPO%"\lz4-java-1.8.0.jar;"%REPO%"\libthrift-0.14.1.jar;"%REPO%"\influxdb-thrift-0.13.2.jar;"%REPO%"\jjwt-api-0.10.7.jar;"%REPO%"\jjwt-impl-0.10.8.jar;"%REPO%"\jjwt-jackson-0.10.7.jar;"%REPO%"\json-smart-2.3.jar;"%REPO%"\accessors-smart-1.2.jar;"%REPO%"\asm-5.0.4.jar;"%REPO%"\gson-2.8.8.jar;"%REPO%"\logback-classic-1.2.10.jar;"%REPO%"\logback-core-1.2.10.jar;"%REPO%"\slf4j-api-1.7.32.jar;"%REPO%"\javax.annotation-api-1.3.2.jar;"%REPO%"\jaxb-api-2.4.0-b180830.0359.jar;"%REPO%"\javax.activation-api-1.2.0.jar;"%REPO%"\jaxb-runtime-3.0.2.jar;"%REPO%"\jakarta.activation-2.0.1.jar;"%REPO%"\jaxb-core-3.0.2.jar;"%REPO%"\jakarta.xml.bind-api-3.0.1.jar;"%REPO%"\txw2-3.0.2.jar;"%REPO%"\istack-commons-runtime-4.0.1.jar;"%REPO%"\jackson-databind-2.9.5.jar;"%REPO%"\jackson-annotations-2.9.0.jar;"%REPO%"\jackson-core-2.9.5.jar;"%REPO%"\iotdb-session-0.13.2.jar;"%REPO%"\commons-io-2.11.0.jar;"%REPO%"\fastjson-1.2.73.jar;"%REPO%"\commons-lang3-3.12.0.jar;"%REPO%"\spring-web-5.1.8.RELEASE.jar;"%REPO%"\spring-beans-5.1.8.RELEASE.jar;"%REPO%"\spring-core-5.1.8.RELEASE.jar;"%REPO%"\spring-jcl-5.1.8.RELEASE.jar;"%REPO%"\spring-boot-autoconfigure-1.5.15.RELEASE.jar;"%REPO%"\spring-boot-1.5.15.RELEASE.jar;"%REPO%"\spring-context-4.3.18.RELEASE.jar;"%REPO%"\spring-boot-starter-web-1.5.15.RELEASE.jar;"%REPO%"\spring-boot-starter-1.5.15.RELEASE.jar;"%REPO%"\spring-boot-starter-logging-1.5.15.RELEASE.jar;"%REPO%"\jcl-over-slf4j-1.7.25.jar;"%REPO%"\jul-to-slf4j-1.7.25.jar;"%REPO%"\log4j-over-slf4j-1.7.25.jar;"%REPO%"\spring-boot-starter-tomcat-1.5.15.RELEASE.jar;"%REPO%"\tomcat-embed-core-8.5.32.jar;"%REPO%"\tomcat-annotations-api-8.5.32.jar;"%REPO%"\tomcat-embed-el-8.5.32.jar;"%REPO%"\tomcat-embed-websocket-8.5.32.jar;"%REPO%"\hibernate-validator-5.3.6.Final.jar;"%REPO%"\validation-api-1.1.0.Final.jar;"%REPO%"\jboss-logging-3.3.0.Final.jar;"%REPO%"\classmate-1.3.1.jar;"%REPO%"\spring-webmvc-4.3.18.RELEASE.jar;"%REPO%"\spring-aop-4.3.18.RELEASE.jar;"%REPO%"\spring-expression-4.3.18.RELEASE.jar;"%REPO%"\spring-boot-configuration-processor-2.1.6.RELEASE.jar;"%REPO%"\sureness-core-0.4.3.jar;"%REPO%"\snakeyaml-1.17.jar;"%REPO%"\spring-boot-starter-test-1.5.15.RELEASE.jar;"%REPO%"\spring-boot-test-1.5.15.RELEASE.jar;"%REPO%"\spring-boot-test-autoconfigure-1.5.15.RELEASE.jar;"%REPO%"\json-path-2.2.0.jar;"%REPO%"\assertj-core-2.6.0.jar;"%REPO%"\mockito-core-1.10.19.jar;"%REPO%"\objenesis-2.1.jar;"%REPO%"\hamcrest-library-1.3.jar;"%REPO%"\jsonassert-1.4.0.jar;"%REPO%"\android-json-0.0.20131108.vaadin1.jar;"%REPO%"\spring-test-4.3.18.RELEASE.jar;"%REPO%"\moshi-1.8.0.jar;"%REPO%"\okio-1.16.0.jar;"%REPO%"\frame_protocol-1.0-SNAPSHOT.jar

@REM ----------------------------------------------------------------------------
@REM ***** CLASSPATH library setting *****
@REM Ensure that any user defined CLASSPATH variables are not used on startup
set CLASSPATH="%BASEDIR%"\conf;

set CLASSPATH=%CLASSPATH%;"%REPO%"\*.jar
set CLASSPATH=%CLASSPATH%;iotdb.IoTDB
goto okClasspath

:append
set CLASSPATH=%CLASSPATH%;%1

goto :eof

:okClasspath
rem echo CLASSPATH: %CLASSPATH%


set ENDORSED_DIR=
if NOT "%ENDORSED_DIR%" == "" set CLASSPATH="%BASEDIR%"\%ENDORSED_DIR%\*;%CLASSPATH%

if NOT "%CLASSPATH_PREFIX%" == "" set CLASSPATH=%CLASSPATH_PREFIX%;%CLASSPATH%

@REM Reaching here means variables are defined and arguments have been captured
:endInit

%JAVACMD% %JAVA_OPTS%  -classpath %CLASSPATH% -Dapp.name="start" -Dapp.repo="%REPO%" -Dapp.home="%BASEDIR%" -Dbasedir="%BASEDIR%" iiot.tsinghua.controller.CollectorController %CMD_LINE_ARGS%
if %ERRORLEVEL% NEQ 0 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=%ERRORLEVEL%

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set CMD_LINE_ARGS=
goto postExec

:endNT
@REM If error code is set to 1 then the endlocal was done already in :error.
if %ERROR_CODE% EQU 0 @endlocal


:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
)

exit /B %ERROR_CODE%
