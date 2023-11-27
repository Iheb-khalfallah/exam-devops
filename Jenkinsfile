pipeline {
    agent any
    environment {
        // Define default values for environment variables
        JAVA_HOME = '/var/lib/jenkins/jdk-17'
        PATH = "$JAVA_HOME/bin:$PATH"
    }
    tools{
        maven 'maven'
    }
    stages {
         stage('Download and Install OpenJDK') {
            steps {
                script {
                    // Download and install OpenJDK 17
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
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://chaima2143: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@github.com/chaima2143/springb-demo.git']])
                sh 'mvn clean install -U'
            }
        }
     }
}
