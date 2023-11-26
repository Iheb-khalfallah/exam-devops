pipeline {
    agent any
    
    tools {
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
                    sh 'java -version'
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

