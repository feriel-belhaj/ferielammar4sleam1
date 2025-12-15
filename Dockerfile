# Utilise une image officielle légère avec Java 17 JRE
FROM eclipse-temurin:17-jre-alpine

# Copie le JAR Spring Boot (généré par spring-boot:repackage ou maven)
COPY target/*.jar app.jar

# Port de votre app Spring Boot (dans votre YAML c'est 8089, pas 8080)
EXPOSE 8089

# Lancement
ENTRYPOINT ["java", "-jar", "/app.jar"]
