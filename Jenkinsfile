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
      //  stage('Push'){
           // steps{
               // script{
                
                    // Push the Docker image
                   // docker.withRegistry('https://registry.hub.docker.com', 'TunisianDeveloper') {
                        //docker.image("ihebkhalfallah/mongo-demo:1").push()
                    //}
                //}
          //  }
       // }
        stage('Pull'){
            steps{
                script{
                
                    // Pull the Docker image
                    docker.image("ihebkhalfallah/mongo-demo:1").push()
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
