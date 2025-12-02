pipeline {
    agent any

    environment {
        // Maven est déjà dans le PATH sur ton Jenkins, pas besoin de M2_HOME
        DOCKERHUB_REPO        = 'feriel014/student-management'
        IMAGE_TAG             = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = 'dockerhub-feriel014'   // ton credential Docker Hub
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Récupération du code depuis GitHub...'
                git credentialsId: 'github-feriel',  // ton token GitHub déjà créé
                    url: 'https://github.com/feriel-belhaj/ferielammar4sleam1.git',
                    branch: 'main'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test -Dmaven.test.skip=true'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'projet', variable: 'TOKEN')]) {   // ton token SonarQube
                    sh """
                        mvn sonar:sonar \
                            -Dsonar.projectKey=student-management \
                            -Dsonar.projectName="Gestion des Étudiants" \
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.token=\$TOKEN \
                            -Dsonar.sources=src/main/java \
                            -Dsonar.tests=src/test/java \
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

        stage('Package') {
            steps {
                sh 'mvn clean package -Dmaven.test.skip=true'
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
            echo "FÉLICITATIONS FERIEL ! Tout est bon !!"
            echo "Docker : https://hub.docker.com/r/${DOCKERHUB_REPO}"
            echo "SonarQube : http://localhost:9000/dashboard?id=student-management"
        }
        failure {
            echo "Oups, il y a eu un souci. Regarde les logs !"
        }
    }
}
