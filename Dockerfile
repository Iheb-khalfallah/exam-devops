# Use a base image with the desired version of OpenJDK
FROM openjdk:17

FROM jenkins/jenkins:latest

# Switches to the root user to perform installation steps that require elevated privileges
USER root

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce-cli

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

USER jenkins


# Set the working directory in the container
WORKDIR /app

# Copy the JAR file into the container
COPY target/mongo-demo-0.0.1-SNAPSHOT.jar .

# Expose the port your application runs on
EXPOSE 9090

# Define the command to run your application
CMD ["java", "-jar", "mongo-demo-0.0.1-SNAPSHOT.jar"]

