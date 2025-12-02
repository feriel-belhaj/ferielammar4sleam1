pipeline {
    agent any
    options {
        skipDefaultCheckout(true)   // EMPÊCHE Jenkins d'utiliser le mauvais credential
    }

    environment {
        DOCKERHUB_REPO = 'feriel014/student-management'
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-feriel014')
    }

    stages {
        stage('Récupération Git') {
            steps {
                echo 'Récupération du code depuis GitHub (repo public)...'
                checkout scmGit(
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/feriel-belhaj/ferielammar4sleam1.git']]
                )
            }
        }

        stage('Tests unitaires') {
            steps {
                sh 'mvn test -Dmaven.test.skip=true'
            }
        }

        stage('Création du livrable') {
            steps {
                sh 'mvn clean package -Dmaven.test.skip=true'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'projet', variable: 'TOKEN')]) {
                    sh """
                        mvn sonar:sonar \
                            -Dsonar.projectKey=projet \
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.login=\$TOKEN
                    """
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

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} .
                    docker tag ${DOCKERHUB_REPO}:${IMAGE_TAG} ${DOCKERHUB_REPO}:latest
                """
            }
        }

        stage('Push Docker Hub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh """
                    docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
                    docker push ${DOCKERHUB_REPO}:latest
                """
            }
        }
    }

    post {
        always { sh 'docker logout || true' }
        success { echo "Tout est bon → http://localhost:9000" }
    }
}
