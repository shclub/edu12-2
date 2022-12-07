#FROM public.ecr.aws/lambda/java11 #:11.2022.12.02.20-x86_64
FROM  amazon/aws-lambda-java:latest
# Copy function code and runtime dependencies from Maven layout

RUN ls -al

RUN pwd

COPY target/classes/* ${LAMBDA_TASK_ROOT}
COPY target/dependency/* ${LAMBDA_TASK_ROOT}/lib/

ENV TZ Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV SPRING_PROFILES_ACTIVE dev

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "com.example.LambdaHandler::handleRequest" ]
