pipeline {
    agent {
        docker {
            image 'jenkins/jenkins:lts'
            args '--group-add docker'
        }
    }
    environment {
        // Define default values for environment variables
        JAVA_HOME = '/var/lib/jenkins/jdk-17'
        PATH = "$JAVA_HOME/bin:$PATH"
        dockerImage = "ihebkhalfallah/springapp:${env.BUILD_NUMBER}"
    }
    tools{
        maven 'maven'
    }
    stages {
         stage('Download and Install OpenJDK') {
            steps {
                script {
                    // Download and install OpenJDK 17
                    sh 'wget https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz'
                    sh 'tar -xvf openjdk-17_linux-x64_bin.tar.gz -C /var/lib/jenkins/'
                    sh 'chmod -R 755 /var/lib/jenkins/jdk-17'
                }
            }
        }
        stage('Build Maven') {
            steps {
                script {
                    env.JAVA_HOME = '/var/lib/jenkins/jdk-17'
                    env.PATH = "$JAVA_HOME/bin:$PATH"
                }
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Iheb-khalfallah/exam-devops.git']])
                sh 'mvn clean install -U'
            }
        }
        stage('test') {
            steps {
                script {
                   	sh './mvnw test'
                }
            }
        }
        stage('Docker Build and Push') {
            steps {
                script {
                    // Authenticate with Docker Hub using Jenkins credentials
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        // Build the Docker image
                        def customImage = docker.build(dockerImage)

                        // Push the Docker image to Docker Hub
                        customImage.push()
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Authenticate with Docker Hub to pull the image
                    docker.withRegistry('https://registry.hub.docker.com', 'Docker-Credential') {
                        // Pull the Docker image
                        docker.image(dockerImage).pull()

                        // Now you can use the Docker image as needed in your deployment steps
                        // Example: docker.image(dockerImage).run('-p 8080:8080 -d')
                    }
                }
            }
        }
     }
    post {
        success {
            echo 'Build and tests passed.'
        }

        failure {
            echo 'Build or tests failed.'
        }
    }
}
