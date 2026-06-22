# ── Stage 1: Build ──────────────────────────────────────────
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# pom.xml separado para aproveitar cache de camadas do Docker
COPY pom.xml .
RUN mvn dependency:go-offline --batch-mode --quiet

# Copia fontes e compila
COPY src/ ./src/
RUN mvn package --batch-mode --quiet -DskipTests

# ── Stage 2: Runtime ────────────────────────────────────────
FROM tomcat:10.1-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY --from=build /app/target/UNIHELP.war \
                  /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
