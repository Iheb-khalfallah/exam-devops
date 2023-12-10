pipeline {
    agent any

    environment {
        JAVA_HOME = '/var/lib/jenkins/jdk-17'
        JAVA_PATH = "$JAVA_HOME/bin:$PATH"
        MINIKUBE_HOME = "/var/lib/jenkins/.minikube"
        MINIKUBE_PATH = "/usr/local/bin:$MINIKUBE_HOME:$PATH"
        KUBE_CONFIG = "$MINIKUBE_HOME/.kube/config"
        KUBERNETES_NAMESPACE = 'default'  // Kubernetes namespace
        KUBERNETES_CLOUD = 'my-k8s-cloud'  // Kubernetes cloud name in Jenkins
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
        
        stage('Install Minikube and Kubectl') {
            steps {
                script {
                    //try {
                        // Download Minikube binary
                        //sh 'curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64'
                        // Make it executable
                        //sh 'chmod +x minikube-linux-amd64'
                        // Move it to /usr/local/bin/ 
                        //sh 'echo Iheb123 | sudo -S mv minikube-linux-amd64 /usr/local/bin/minikube'
                        
                        // Start Minikube
                    sh 'minikube start '
                        
                        // Install kubectl
                        //sh 'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"'
                        //sh 'chmod +x kubectl'
                        //sh 'echo Iheb123 | sudo -S mv kubectl /usr/local/bin/kubectl'
                        
                    //} catch (Exception e) {
                        //currentBuild.result = 'FAILURE'
                        //error("Failed to install Minikube and kubectl: ${e.message}")
                    //} finally {
                        // Clean up downloaded files
                        //sh 'rm -f minikube-linux-amd64 kubectl'
                    //}
                }
            }
        }


        stage('Build Maven') {
            steps {
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

        stage('Build Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build("ihebkhalfallah/mongo-demo:1")
                }
            }
        }

        //stage('Push') {
            //steps {
                //script {
                    // Push the Docker image
                    //docker.withRegistry('https://registry.hub.docker.com', 'TunisianDeveloper') {
                        //docker.image("ihebkhalfallah/mongo-demo:1").push()
                    //}
                //}
            //}
        //}

        //stage('Pull'){
            //steps{
                //script{
                    // Pull the Docker image
                    //docker.withRegistry('https://registry.hub.docker.com', 'TunisianDeveloper') {
                        //docker.image("ihebkhalfallah/mongo-demo:1").pull()
                    //}
                //}
            //}
        //}

        stage('Docker Compose UP') {
            steps {
                script {
                    // Deploy the Docker Compose environment
                    sh 'docker-compose down'
                    sh 'docker-compose up -d'
                }
            }
        }

        stage('Configure Kubernetes') {
            steps {
                script {
                    // Check if Minikube is running
                    def minikubeStatus = sh(script: 'minikube status --format="{{.MinikubeStatus}}"', returnStdout: true).trim()

        
                    if (minikubeStatus != 'Running') {
                        error "Minikube is not running. Please start Minikube first."
                    }
        
                    // Check if the Kubernetes configuration file exists
                    def kubeConfigPath = sh(script: 'echo $MINIKUBE_HOME/.kube/config', returnStdout: true).trim()
        
                    if (!fileExists(kubeConfigPath)) {
                        error "Kubernetes configuration file not found. Ensure Minikube is properly configured."
                    }
        
                    // Copy the Kubernetes configuration
                    sh "cp $kubeConfigPath $KUBE_CONFIG"
                }
            }
        }


        stage('Build and Deploy to Kubernetes') {
            steps {
                script {
                    // Build and deploy your application using kubectl
                    sh 'kubectl config use-context minikube'
                    // Adjust this section based on your actual application and deployment needs
                    sh 'kubectl run my-app --image=nginx --port=70'
                    sh 'kubectl expose deployment my-app --type=NodePort --port=70'
                }
            }
        }
    }

    post {
        success {
            echo 'Build, tests, and Docker image creation, push, and pull passed.'
        }

        failure {
            echo 'Build, tests, or Docker image creation, push, and pull failed.'
        }

        always {
            // Cleanup: Stop Minikube after the pipeline is done
            script {
                sh 'minikube stop'
            }
        }
    }
}

