# Use a base image with the desired version of OpenJDK
FROM openjdk:17

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file into the container
COPY target/mongo-demo-0.0.1-SNAPSHOT.jar .

# Expose the port your application runs on
EXPOSE 8090

# Define the command to run your application
CMD ["java", "-jar", "mongo-demo-0.0.1-SNAPSHOT.jar"]
