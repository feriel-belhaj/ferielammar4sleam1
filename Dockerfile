# Image légère avec Java 17 (ou 11 selon ton projet)
FROM openjdk:17-jdk-slim

# Copie le .jar généré par Maven
COPY target/*.jar app.jar

# Port Spring Boot
EXPOSE 8080

# Lance l'application
ENTRYPOINT ["java","-jar","/app.jar"]
