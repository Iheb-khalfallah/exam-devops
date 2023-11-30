pipeline {
    agent any

    environment {
        JAVA_HOME = '/var/lib/jenkins/jdk-17'
        PATH = "$JAVA_HOME/bin:$PATH"
    }

    tools {
        maven 'maven'
        dockerTool 'docker'
    }

    stages {
        stage('Download and Install OpenJDK') {
            steps {
                script {
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

        stage('Build Docker Image') {
        steps {
            script {
                // Build and push Docker image
                docker.build("ihebkhalfallah/mongo-demo:${env.BUILD_NUMBER}")
                docker.image("ihebkhalfallah/mongo-demo:${env.BUILD_NUMBER}").push()
                docker.withRegistry('https://registry.hub.docker.com', 'IHEBKHALFALLAH') {
                    docker.image("ihebkhalfallah/mongo-demo:${env.BUILD_NUMBER}").push()
                }
            }
        }
    }

        stage('Test') {
            steps {
                script {
                    sh './mvnw test'
                }
            }
        }
    }

    post {
        success {
            echo 'Build, tests, and Docker image creation passed.'
        }

        failure {
            echo 'Build, tests, or Docker image creation failed.'
        }
    }
}
