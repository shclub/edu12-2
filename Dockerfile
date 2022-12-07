FROM  maven:3.8.4-openjdk-17 AS MAVEN_BUILD

RUN mkdir -p build
WORKDIR /build

COPY pom.xml ./
COPY src ./src

COPY . ./
RUN mvn package -DskipTests


 FROM eclipse-temurin:17.0.2_8-jre-alpine

# FROM public.ecr.aws/lambda/java:11

# FROM  amazon/aws-lambda-java:latest
# Copy function code and runtime dependencies from Maven layout


#COPY --from=MAVEN_BUILD /build/target/*.jar app.jar

# COPY --from=MAVEN_BUILD /build/target/classes ${LAMBDA_TASK_ROOT}
# COPY --from=MAVEN_BUILD /build/target/dependency/* ${LAMBDA_TASK_ROOT}/lib/

ENV TZ Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV SPRING_PROFILES_ACTIVE dev

COPY --from=MAVEN_BUILD /build/target/dependency/* /function/
COPY --from=MAVEN_BUILD /build/target/thirdproject.jar /function

RUN ls /build/target/

#ENTRYPOINT [ "/opt/java/openjdk/bin/java", "-cp", "/function/*", "com.amazonaws.services.lambda.runtime.api.client.AWSLambda" ]

ENTRYPOINT [ "sh", "-c", "java /function/*", "com.amazonaws.services.lambda.runtime.api.client.AWSLambda" ]

# CMD ["de.rieckpil.blog.Java15Lambda::handleRequest"]

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "com.kt.edu.thirdproject.StreamLambdaHandler::handleRequest" ]
