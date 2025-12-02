pipeline {
    agent any

 environment {
     DOCKERHUB_REPO = 'feriel014/student-management'
     IMAGE_TAG = "${BUILD_NUMBER}"
     DOCKERHUB_CREDENTIALS = credentials('dockerhub-feriel014')
 }

 stages {
     stage('Checkout') {
         steps {
             git url: 'https://github.com/feriel-bhaj/ferielammar4sleam1.git', branch: 'main'
         }
     }

     stage('Tests unitaires') {
         steps {
             sh 'mvn test'                         // on enlève le skip
         }
     }

     stage('SonarQube Analysis') {
         steps {
             sh 'mvn clean verify sonar:sonar'
         }
     }

     stage('Quality Gate') {
         steps {
             timeout(time: 5, unit: 'MINUTES') {
                 waitForQualityGate abortPipeline: true
             }
         }
     }

     stage('Build & Push Docker') {
         when { expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') } }  // seulement si Sonar passe
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
     always { sh 'docker logout || true' }
     success { echo 'Tout est OK — Docker + SonarQube' }
 }
}
