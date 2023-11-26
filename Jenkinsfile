pipeline {
    agent any

    environment {
        // Set Maven home
        MAVEN_HOME = '/home/iheb_kh/apache-maven-3.9.5'
    }
    
    tools {
        // or use the exact name configured in Jenkins for Maven
        maven 'M3' 

        // Specify the JDK installation defined in Jenkins configuration
        jdk 'Java 17'
    }
    
    stages {
        stage('Checkout') {
            steps {
                script {
                    deleteDir()
                    checkout scm
                }
            }
        }

        stage('Build and Test') {
            steps {
                script {
                    MAVEN_BIN = "${MAVEN_HOME}/bin"
                    env.PATH = "${MAVEN_BIN}:${env.PATH}"
                    sh 'java -version'
                    sh 'mvn -version'
                    sh './mvnw clean package'
                    sh './mvnw test'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying...'
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

