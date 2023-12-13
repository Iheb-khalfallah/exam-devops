pipeline {
    agent any

    environment {
        JAVA_HOME = "${WORKSPACE}/jdk-17"
        JAVA_PATH = "${JAVA_HOME}/bin:${PATH}"
        
        MINIKUBE_HOME = "${WORKSPACE}/.minikube"
        MINIKUBE_PATH = "/usr/local/bin:$MINIKUBE_HOME:$PATH"
        
        SONAR_TOKEN = credentials('SONARQUBE_TOKEN')
        
    }

    tools {
        maven 'maven'
        dockerTool 'docker'
    }

    stages {

        
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
        
        //stage('Download and Install OpenJDK') {
            //steps {
                //script {
                    // Create the target directory in the workspace
                    //sh "mkdir -p ${WORKSPACE}/jdk-17"
                    
                    // Download and install OpenJDK 17
                   // sh 'wget https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz'
                   // sh 'tar -xvf openjdk-17_linux-x64_bin.tar.gz -C ${WORKSPACE}'
                   // sh "chmod -R 755 ${WORKSPACE}/jdk-17"
                    
                    // Set JAVA_HOME globally
                   // env.JAVA_HOME = "${WORKSPACE}/jdk-17"
                   // env.JAVA_PATH = "${env.JAVA_HOME}/bin:${env.JAVA_PATH}"
              //  }
           // }
       // }



        //stage('Install Nginx') {
            //steps {
                //script {
                    // Create a temporary sudoers file
                    //def sudoersFile = '/tmp/jenkins_sudoers'
                    //sh 'echo "jenkins ALL=(ALL) NOPASSWD: /usr/bin/zypper, /usr/bin/systemctl" > ' + sudoersFile
        
                    // Copy the temporary sudoers file to /etc/sudoers.d/
                    //sh 'echo Iheb123 | sudo -S cp ' + sudoersFile + ' /etc/sudoers.d/jenkins'
        
                    // Remove the temporary sudoers file
                    //sh 'rm ' + sudoersFile
        
                    // Update and install Nginx (non-interactive)
                    //sh 'echo Iheb123 | sudo -S zypper --non-interactive --no-gpg-checks install -y nginx'
        
                    // Start Nginx
                    //sh 'echo Iheb123 | sudo -S systemctl start nginx'
        
                    // Enable Nginx to start on boot
                    //sh 'echo Iheb123 | sudo -S systemctl enable nginx'
                //}
            //}
        //}

        
        //stage('Install/Start Minikube and Install Kubectl') {
            //steps {
                //script {
                   // try {
                        // Download Minikube binary
                        //sh 'curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64'
                        // Make it executable
                        //sh 'chmod +x minikube-linux-amd64'
                        // Move it to /usr/local/bin/
                        //sh 'echo Iheb123 | sudo -S mv minikube-linux-amd64 /usr/local/bin/minikube'
        
                        // Start Minikube with --home option
                        //sh 'minikube start'
        
                        // Install kubectl
                        //sh 'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"'
                        //sh 'chmod +x kubectl'
                        //sh 'echo Iheb123 | sudo -S mv kubectl /usr/local/bin/kubectl'
                   // } catch (Exception e) {
                       // currentBuild.result = 'FAILURE'
                        //error("Failed to install Minikube and kubectl: ${e.message}")
                    //} finally {
                            //Clean up downloaded files
                       // sh 'rm -f minikube-linux-amd64 kubectl'
                  // }
                //}
            //}
        //}



 
        stage('Build Maven') {
            steps {
                script {
                    env.JAVA_HOME = '${WORKSPACE}/jdk-17'
                    env.JAVA_PATH = "$JAVA_HOME/bin:$PATH"
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


        stage('Build Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build("ihebkhalfallah/mongo-demo:1")
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    // Push the Docker image
                    docker.withRegistry('https://registry.hub.docker.com', 'TunisianDeveloper') {
                        docker.image("ihebkhalfallah/mongo-demo:1").push()
                    }
                }
            }
        }

        //stage('Pull'){
            //steps{
                //script{
                    // Pull the Docker image
                     //docker.withRegistry('https://registry.hub.docker.com', 'TunisianDeveloper') {
                        //docker.image("ihebkhalfallah/mongo-demo:1").pull()
                    //}
                //}
           // }
       // }

        stage('Docker Compose UP') {
            steps {
                script {
                    // Deploy the Docker Compose environment
                    sh 'docker-compose up -d'
                }
            }
        }

        stage('Build and Deploy to Kubernetes') {
            steps {
                script {
                   //kubernetesDeploy (configs: 'deploymentservice.yaml', kubeconfigId: 'kubeconf')
                    sh 'kubectl create --save-config -f deploymentservice.yaml' 
                }
            }
        }





        stage('SonarQube Analysis') {
            steps {
                script {
                    // Configure SonarQube scanner
                    withSonarQubeEnv('sonar-server') {
                        // Run SonarQube analysis
                        sh "mvn sonar:sonar -Dsonar.login=${env.SONAR_TOKEN}"
                    }
                }
            }
        }



    }

    post {
        success {
            echo 'Build, tests, and Docker image creation, push, pull and deployment passed.'
        }

        failure {
            echo 'Build, tests, or Docker image creation, push, pull and deployment failed.'
        }

        //always {
            //Cleanup: Stop Minikube after the pipeline is done
          //  script {
            //    sh 'minikube stop'
            //}
        //}
    }
}

