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
        stage('Prune Docker Data') {
            steps {
                script {
                    sh 'docker system prune -a --volumes -f'
                }
            }
        }
        stage('Docker Login') {
            steps {
                script {
                    // Docker login
                    withCredentials([usernamePassword(credentialsId: 'TunisianDeveloper', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                         sh "docker login -u \$DOCKER_HUB_USERNAME -p \$DOCKER_HUB_PASSWORD docker.io"
                    }
                }
            }
        }
        stage('Build SpringBoot-app Image'){
            steps{
                script{
                    // Build the Docker image
                    docker.build("ihebkhalfallah/mongo-demo:1")
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
        stage('Push SpringBoot-app Image'){
            steps{
                script{
                     //Push the Docker image
                    docker.withRegistry('https://registry.hub.docker.com', 'TunisianDeveloper') {
                        docker.image("ihebkhalfallah/mongo-demo:1").push()
                    }
                }
            }
        }
        stage('Build and Push MongoDB Initialization Image') {
            steps {
                script {
                    // Build the Docker image for MongoDB initialization
                    docker.build("mongodb-image:1", "-f Dockerfile-mongodb-init .")

                    // Push the Docker image to your registry
                    docker.withRegistry('https://registry.hub.docker.com', 'TunisianDeveloper') {
                        docker.image("mongodb-image:1").push()
                    }
                }
            }
        }
        stage('Pull SpringBoot-app and MOngoDB Images'){
            steps{
                script{
                    // Pull the Docker images
                    docker.image("ihebkhalfallah/mongodb-image:1").pull()
                    docker.image("ihebkhalfallah/mongo-demo:1").pull()
                }
            }
        }
        stage('Start Container') {
            steps {
                script {
                    sh 'docker-compose version'
                    // Run Docker Compose
                    sh 'docker compose ps'
                    sh 'docker compose down'
                    sh 'docker compose up -d --no-color --wait'
                    sh 'docker compose ps'
                }
            }
        }
        
    }

    post {
        success {
            echo 'Build, tests, and Docker image creation/pull passed.'
        }

        failure {
            echo 'Build, tests, or Docker image creation/pull failed.'
        }
    }
}
