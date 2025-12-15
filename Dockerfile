# Image de base légère et officielle pour Java 17
FROM eclipse-temurin:17-jre-alpine

# Créé un utilisateur non-root (sécurité)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Répertoire de travail
WORKDIR /app

# Copie le JAR
COPY target/*.jar app.jar

# Utilisateur non-root
USER appuser

# Port exposé
EXPOSE 8089

# CORRECTION ICI : on est dans /app, donc le JAR est à "app.jar" et non "/app.jar"
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]
