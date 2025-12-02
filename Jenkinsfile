pipeline {
    agent any

    environment {
        M2_HOME = "/usr/share/maven"
        PATH = "${env.M2_HOME}/bin:${env.PATH}"
        DOCKERHUB_CREDENTIALS = 'dockerhub-cred'   
        IMAGE_NAME = 'youssef21112/myproj'
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/Youssseef21/Harrane_yousef_Sleam1.git', branch: 'main'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test -Dspring.profiles.active=test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Inject the SONAR_AUTH_TOKEN credential from Jenkins
                withCredentials([string(credentialsId: 'SONAR_AUTH_TOKEN', variable: 'TOKEN')]) {
                    sh """
                        mvn sonar:sonar \
                            -Dsonar.projectKey= projet\
                            -Dsonar.host.url=http://192.168.175.131:9000 \
                            -Dsonar.login=$TOKEN
                    """
                }
            }
        }

        stage('Package') {
            steps {
                sh 'mvn clean package -Dspring.profiles.active=test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${IMAGE_NAME}:latest"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished"
        }
        success {
            echo "Build succeeded!"
        }
        failure {
            echo "Build failed!"
        }
    }
}
