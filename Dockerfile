FROM openjdk:8-jdk-slim
VOLUME /tmp
ADD build/libs/simpledockerapp-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
