pipeline {
    agent any
<<<<<<< HEAD

=======
    
>>>>>>> 4c91008 (kubernities)
    environment {
        DOCKERHUB_REPO = 'feriel014/student-management1'
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-feriel014')
<<<<<<< HEAD
    }

    stages {

=======
        KUBE_NAMESPACE = 'devops'
    }
    
    stages {
>>>>>>> 4c91008 (kubernities)
        stage('Récupération Git') {
            steps {
                echo 'Récupération du code depuis GitHub...'
                git url: 'https://github.com/feriel-belhaj/ferielammar4sleam1.git', branch: 'main'
            }
        }
<<<<<<< HEAD

=======
        
>>>>>>> 4c91008 (kubernities)
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
<<<<<<< HEAD

=======
        
>>>>>>> 4c91008 (kubernities)
        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
<<<<<<< HEAD

=======
        
>>>>>>> 4c91008 (kubernities)
        stage('Création du livrable') {
            steps {
                sh 'mvn package -DskipTests'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
<<<<<<< HEAD

=======
        
>>>>>>> 4c91008 (kubernities)
        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} .
                    docker tag ${DOCKERHUB_REPO}:${IMAGE_TAG} ${DOCKERHUB_REPO}:latest
                """
            }
        }
<<<<<<< HEAD

=======
        
>>>>>>> 4c91008 (kubernities)
        stage('Push Docker Hub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh """
                    docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
                    docker push ${DOCKERHUB_REPO}:latest
                """
            }
        }
<<<<<<< HEAD
    }

=======
        
        stage('Deploy MySQL to Kubernetes') {
            steps {
                script {
                    echo '🗄️ Déploiement de MySQL sur Kubernetes...'
                    sh """
                        kubectl apply -f k8s/mysql-deployment.yaml
                        kubectl wait --for=condition=ready pod -l app=mysql -n ${KUBE_NAMESPACE} --timeout=300s || true
                        kubectl get pods -n ${KUBE_NAMESPACE} -l app=mysql
                    """
                }
            }
        }
        
        stage('Deploy Spring App to Kubernetes') {
            steps {
                script {
                    echo '🚀 Déploiement de l\'application Spring Boot sur Kubernetes...'
                    sh """
                        # Mettre à jour l'image dans le deployment
                        kubectl set image deployment/spring-app spring-app=${DOCKERHUB_REPO}:${IMAGE_TAG} -n ${KUBE_NAMESPACE} || kubectl apply -f k8s/spring-deployment.yaml
                        
                        kubectl wait --for=condition=ready pod -l app=spring-app -n ${KUBE_NAMESPACE} --timeout=300s || true
                        
                        kubectl get deployments -n ${KUBE_NAMESPACE}
                        kubectl get pods -n ${KUBE_NAMESPACE}
                        kubectl get services -n ${KUBE_NAMESPACE}
                    """
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    echo '✅ Vérification du déploiement...'
                    sh """
                        echo "🌐 URL du service:"
                        minikube service spring-service -n ${KUBE_NAMESPACE} --url || true
                        
                        echo "📋 Logs des pods Spring Boot:"
                        kubectl logs -l app=spring-app -n ${KUBE_NAMESPACE} --tail=50 || true
                    """
                }
            }
        }
    }
    
>>>>>>> 4c91008 (kubernities)
    post {
        always {
            sh 'docker logout || true'
        }
        success {
<<<<<<< HEAD
            echo "Image poussée avec succès ! https://hub.docker.com/r/feriel014/student-management1"
=======
            echo "✅ Pipeline terminé avec succès !"
            echo "🐳 Image Docker: https://hub.docker.com/r/feriel014/student-management1"
            sh """
                echo "📊 État du cluster Kubernetes:"
                kubectl get all -n ${KUBE_NAMESPACE} || true
            """
        }
        failure {
            echo "❌ Le pipeline a échoué"
            sh """
                echo "🔍 Logs de debug Kubernetes:"
                kubectl get events -n ${KUBE_NAMESPACE} --sort-by='.lastTimestamp' || true
            """
>>>>>>> 4c91008 (kubernities)
        }
    }
}
