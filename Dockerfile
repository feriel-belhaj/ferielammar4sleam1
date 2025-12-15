# Image de base légère et officielle pour Java 17 (JRE seulement)
FROM eclipse-temurin:17-jre-alpine

# Créé un utilisateur non-root pour plus de sécurité (meilleure pratique Docker/K8s)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Définit le répertoire de travail
WORKDIR /app

# Copie le JAR construit
COPY target/*.jar app.jar

# Change l'utilisateur (ne tourne pas en root !)
USER appuser

# Port exposé (8089 car ton app Spring Boot écoute probablement dessus)
EXPOSE 8089

# Optimisation pour Spring Boot (accélère le démarrage)
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app.jar"]
