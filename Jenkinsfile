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
                    withEnv(["JAVA_HOME=${env.JAVA_HOME}", "PATH=${env.PATH}"]) {
                        checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Iheb-khalfallah/exam-devops.git']])
                        sh 'mvn clean install -U'
                    }
                }
            }
        }

        stage('Docker Login') {
            steps {
                script {
                    container('docker') {
                        withCredentials([usernamePassword(credentialsId: 'TunisianDeveloper', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                            sh "docker login -u \$DOCKER_HUB_USERNAME -p \$DOCKER_HUB_PASSWORD docker.io"
                        }
                    }
                }
            }
        }

        stage('Build App Image') {
            steps {
                script {
                    container('docker') {
                        docker.build("ihebkhalfallah/mongo-demo:1")
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    withEnv(["JAVA_HOME=${env.JAVA_HOME}", "PATH=${env.PATH}"]) {
                        container('maven') {
                            sh './mvnw test'
                        }
                    }
                }
            }
        }

        stage('Push App Image') {
            steps {
                script {
                    container('docker') {
                        withCredentials([usernamePassword(credentialsId: 'TunisianDeveloper', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                            docker.withRegistry('https://registry.hub.docker.com', 'TunisianDeveloper') {
                                docker.image("ihebkhalfallah/mongo-demo:1").push()
                            }
                        }
                    }
                }
            }
        }

        stage('Build and Push MongoDB Initialization Image') {
            steps {
                script {
                    container('docker') {
                        docker.build("mongodb-image:1", "-f Dockerfile-mongodb-init .")
                        docker.withRegistry('https://registry.hub.docker.com', 'TunisianDeveloper') {
                            docker.image("ihebkhalfallah/mongodb-image:1").push()
                        }
                    }
                }
            }
        }

        stage('Pull App and MongoDB Images') {
            steps {
                script {
                    container('docker') {
                        docker.image("ihebkhalfallah/mongodb-image:1").pull()
                        docker.image("ihebkhalfallah/mongo-demo:1").pull()
                    }
                }
            }
        }

        stage('Start Container') {
            steps {
                script {
                    container('docker') {
                        sh 'docker-compose version'
                        sh 'docker compose ps'
                        sh 'docker compose down'
                        sh 'docker compose up -d --no-cache --wait'
                        sh 'docker compose ps'
                    }
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
