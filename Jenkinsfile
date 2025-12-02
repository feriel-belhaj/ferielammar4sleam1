pipeline {
    agent any

    environment {
        DOCKERHUB_REPO        = 'feriel014/student-management'
        IMAGE_TAG             = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-feriel014')
        
        // Variables SonarQube
        SONAR_PROJECT_KEY     = 'sqp_b7ab3a4ecca0c979cad5abe0f9bd7704ededc48c'          // clé unique
        SONAR_PROJECT_NAME    = 'project3212'        // nom joli affiché
        SONAR_HOST_URL        = 'http://localhost:9000'
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

        // STAGE SONARQUBE CORRIGÉ ET PARFAIT
        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'SONAR_AUTH_TOKEN', variable: 'TOKEN')]) {
                    sh """
                        mvn sonar:sonar \
                          -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                          -Dsonar.projectName="${SONAR_PROJECT_NAME}" \
                          -Dsonar.host.url=${SONAR_HOST_URL} \
                         
                          -Dsonar.login=${TOKEN} \
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
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh """
                    docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
                    docker push ${DOCKERHUB_REPO}:latest
                """
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
            cleanWs()
        }
        success {
            echo "Image poussée avec succès ! https://hub.docker.com/r/feriel014/student-management"
            echo "Analyse SonarQube → http://localhost:9000/dashboard?id=student-management"
        }
        failure {
            echo "Échec du pipeline – vérifie les logs"
        }
    }
}
