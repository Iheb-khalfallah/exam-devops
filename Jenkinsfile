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
        
        //stage('Download and Install OpenJDK') {
            //steps {
                //script {
                    // Download and install OpenJDK 17
                    //sh 'wget https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz'
                    //sh 'tar -xvf openjdk-17_linux-x64_bin.tar.gz -C /var/lib/jenkins/'
                    //sh 'chmod -R 755 /var/lib/jenkins/jdk-17'
                //}
            //}
        //}
        
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

        stage('Test') {
            steps {
                script {
                    sh './mvnw test'
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
        
        stage('Build Image'){
            steps{
                script{
                    // Build the Docker image
                    docker.build("ihebkhalfallah/mongo-demo:1")
                }
            }
        }
        
        stage('Push'){
            steps{
                script{
               
                    // Push the Docker image
                    docker.withRegistry('https://registry.hub.docker.com', 'TunisianDeveloper') {
                        docker.image("ihebkhalfallah/mongo-demo:1").push()
                    }
                }
            }
        }
        
        stage('Pull'){
            steps{
                script{
                    // Pull the Docker image
                    docker.withRegistry('https://registry.hub.docker.com', 'TunisianDeveloper') {
                        docker.image("ihebkhalfallah/mongo-demo:1").pull()
                    }
                }
            }
        }
        
        stage('Docker Compose UP') {
            steps {
                script {
                    // Deploy the Docker Compose environment
                    sh 'docker-compose down'
                    sh 'docker-compose up -d'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            agent {
                kubernetes {
                    cloud 'your-kubernetes-cloud-name'
                    label 'kubernetes-pod-label'
                }
            }
            steps {
                container('your-kubernetes-container-name') {
                    script {
                        sh 'kubectl apply -f spring-boot-app-deployment.yaml'
                    }
                }
            }
        }


        //stage('Clean Up') {
            //steps {
                //script {
                    // Clean up Docker images and containers
                    //sh 'docker system prune -a --volumes -f'

                    // Clean up Jenkins workspace
                    //cleanWs()
                //}
            //}
        //}
    }

    post {
        success {
            echo 'Build, tests, and Docker image creation, push and pull passed.'
        }

        failure {
            echo 'Build, tests, or Docker image creation, push and pull failed.'
        }
    }
}
