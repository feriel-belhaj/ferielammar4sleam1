pipeline {
    agent any

    environment {
        DOCKERHUB_REPO        = 'feriel014/student-management'
        IMAGE_TAG             = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = 'dockerhub-feriel014' 
        SONAR_TOKEN = 'jenkins-sonar' 
    }

    /*stages {
        stage('Checkout') {
            steps {
                echo 'Récupération du code depuis GitHub...'
                git credentialsId: 'github-feriel',  // ton token GitHub
                    url: 'https://github.com/feriel-belhaj/ferielammar4sleam1.git',
                    branch: 'main'
            }
        }

        stage('Build & Test') {
            steps {
                // Compiler et exécuter les tests
                sh 'mvn clean test'
            }
        }*/

          stage('Analyse SonarQube') {
    steps {
        withCredentials([string(credentialsId: 'jenkins-sonar', variable: 'SONAR_TOKEN')]) {
            withSonarQubeEnv('SonarQubeServer') {
                sh "mvn sonar:sonar -Dsonar.projectKey=FerielDevopsProject -Dsonar.login=${SONAR_TOKEN} -Dsonar.java.binaries=target/classes"
            }
        }
    }
}

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Package') {
            steps {
                sh 'mvn clean package'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} .
                    docker tag ${DOCKERHUB_REPO}:${IMAGE_TAG} ${DOCKERHUB_REPO}:latest
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-feriel014',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh """
                        docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
                        docker push ${DOCKERHUB_REPO}:latest
                    """
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
            cleanWs()
        }
        success {
            echo " FÉLICITATIONS ! Tout est bon !!"
            echo "Docker : https://hub.docker.com/r/${DOCKERHUB_REPO}"
            echo "SonarQube : http://<IP_SONAR>:9000/dashboard?id=student-management"
        }
        failure {
            echo "Oups, il y a eu un souci. Regarde les logs !"
        }
    }
}
