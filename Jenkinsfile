pipeline {
    agent any

    tools {
        jdk 'JDK17'          // ← change le nom si ton JDK dans Jenkins s'appelle autrement
        maven 'Maven3.9'     // ← change si ton Maven s'appelle autrement
    }

    environment {
        // Nom de ton projet dans SonarQube
        SONAR_PROJECT_KEY = 'student-management'
        SONAR_PROJECT_NAME = 'Gestion des Étudiants'
        
        // URL de ton serveur SonarQube (change si besoin)
        SONAR_HOST_URL = 'http://ton-serveur-sonarqube:9000'
        
        // Token SonarQube (à mettre dans Jenkins Credentials → ID = "sonar-token")
        SONAR_TOKEN = credentials('sonar-token')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/ton-user/student-management.git'
                    // ou ton repo GitLab/Bitbucket
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube Server') {   // ← nom exact de ta config Sonar dans Jenkins
                    sh '''
                        mvn sonar:sonar \
                          -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                          -Dsonar.projectName="${SONAR_PROJECT_NAME}" \
                          -Dsonar.host.url=${SONAR_HOST_URL} \
                          -Dsonar.token=${SONAR_TOKEN} \
                          -Dsonar.sources=src \
                          -Dsonar.java.binaries=target/classes \
                          -Dsonar.sourceEncoding=UTF-8
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
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Analyse SonarQube réussie ! Ton projet s’appelle maintenant "Gestion des Étudiants" dans SonarQube 🎉'
        }
        failure {
            echo 'Échec de l’analyse ou Quality Gate KO 😭'
        }
    }
}
