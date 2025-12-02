pipeline {
    agent any

    environment {
        DOCKERHUB_REPO = 'feriel014/student-management'
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-feriel014')
    }

    stages {
        stage('Récupération Git') {
            steps {
                git url: 'https://github.com/feriel-bhaj/ferielammar4sleam1.git', branch: 'main'
            }
        }

        stage('Tests unitaires') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                sh 'mvn clean verify sonar:sonar'        // exactement la commande de la prof
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true   // bloque si rouge
                }
            }
        }

        // SEULEMENT si le Quality Gate est vert → on construit et pousse l’image
        stage('Build & Push Docker Image') {
            steps {
                sh """
                    docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} .
                    docker tag ${DOCKERHUB_REPO}:${IMAGE_TAG} ${DOCKERHUB_REPO}:latest
                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                    docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
                    docker push ${DOCKERHUB_REPO}:latest
                """
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
        success {
            echo "Build réussi + Qualité OK + Image Docker poussée !"
        }
        failure {
            echo "Échec → regarde le Quality Gate SonarQube"
        }
    }
}
