pipeline {
    agent any

    environment {
        DOCKERHUB_REPO = 'feriel014/student-management1'
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-feriel014')
    }

    stages {

        stage('Récupération Git') {
            steps {
                echo 'Récupération du code depuis GitHub...'
                git url: 'https://github.com/feriel-belhaj/ferielammar4sleam1.git', branch: 'main'
            }
        }

        stage('Analyse Qualité - SonarQube + Tests + JaCoCo') {
            steps {
                withSonarQubeEnv('jenkins-sonar') {
                    sh '''
                        mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=student-management \
                        -Dsonar.projectName=student-management
                    '''
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

        stage('Création du livrable') {
            steps {
                sh 'mvn package -DskipTests'
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
        }
        success {
            echo "Image poussée avec succès ! https://hub.docker.com/r/feriel014/student-management1"
        }
    }
}
