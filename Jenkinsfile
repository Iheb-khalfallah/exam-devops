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
                sh 'docker logout'
                // Docker login
                sh 'docker login -u ihebkhalfallah -p IHEBhesoyam123'
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
