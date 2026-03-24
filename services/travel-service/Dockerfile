FROM maven:3.9-eclipse-temurin-17-alpine AS builder

WORKDIR /build

COPY . .

RUN mvn clean package -DskipTests -f pom.xml

FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=builder /build/services/travel-service/target/travel-service-*.jar app.jar

EXPOSE 8003

ENTRYPOINT ["java", "-jar", "app.jar"]
