pipeline {
    agent any

    environment {
        DOCKERHUB_REPO     = 'feriel014/student-management'
        IMAGE_TAG          = "${BUILD_NUMBER}"

        SONAR_PROJECT_KEY  = 'student-management'
        SONAR_PROJECT_NAME = 'Gestion des Étudiants'
        SONAR_HOST_URL     = 'http://localhost:9000'
    }

    stages {
        stage('Récupération Git') {
            steps {
                echo 'Récupération du code depuis GitHub...'
                git url: 'https://github.com/feriel-bhaj/ferielammar4sleam1.git', branch: 'main'
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
                withCredentials([string(credentialsId: 'projet', variable: 'SONAR_TOKEN')]) {
                    sh """
                        mvn sonar:sonar \
                          -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                          -Dsonar.projectName="${SONAR_PROJECT_NAME}" \
                          -Dsonar.host.url=${SONAR_HOST_URL} \
                          -Dsonar.login=${SONAR_TOKEN} \
                          -Dsonar.sources=src \
                          -Dsonar.java.binaries=target/classes \
                          -Dsonar.sourceEncoding=UTF-8
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
            echo "Build #${BUILD_NUMBER} réussi !"
            echo "Docker → https://hub.docker.com/r/${DOCKERHUB_REPO}/tags"
            echo "SonarQube → http://localhost:9000/dashboard?id=${SONAR_PROJECT_KEY}"
        }
        failure {
            echo "Build #${BUILD_NUMBER} échoué – voir les logs ci-dessus"
        }
    }
}
