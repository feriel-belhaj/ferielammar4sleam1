# Change cette ligne :
# FROM openjdk:17-jdk-slim

# Par celle-ci (c’est l’image officielle qui MARCHE À COUP SÛR sur la VM école) :
FROM openjdk:17-jdk

# Le reste reste IDENTIQUE
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]
