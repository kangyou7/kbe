FROM registry.secuiot/base_java:8u151

ADD dsp-svc-alarm-21-18.07.13.10.07-SNAPSHOT.jar /dsp-svc-alarm-21-18.07.13.10.07-SNAPSHOT.jar

ENTRYPOINT ["java", "-Dspring.profiles.active=stg", "-Dtenant=21", "-jar", "/dsp-svc-alarm-21-18.07.13.10.07-SNAPSHOT.jar"]

EXPOSE 8080
