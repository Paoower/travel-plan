FROM maven:3.9-eclipse-temurin-17-alpine AS builder

WORKDIR /build

# Copy the entire project
COPY . .

# Build auth-service (maven will resolve all relative paths correctly)
RUN mvn clean package -DskipTests -f pom.xml

# Runtime stage
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy jar from builder
COPY --from=builder /build/services/auth-service/target/auth-service-*.jar app.jar

EXPOSE 8001

ENTRYPOINT ["java", "-jar", "app.jar"]
