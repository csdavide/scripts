@echo off
%MAVEN_HOME%\bin\mvn -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dhttps.protocols=TLSv1.2 -s C:\u2031\progetti\work\resource\mvnr\settings.xml %*