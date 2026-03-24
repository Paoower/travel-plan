FROM maven:3.9-eclipse-temurin-17-alpine AS builder

WORKDIR /build

COPY . .

RUN mvn clean package -DskipTests -f pom.xml

FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=builder /build/services/payment-service/target/payment-service-*.jar app.jar

EXPOSE 8004

ENTRYPOINT ["java", "-jar", "app.jar"]
