pipeline {
    agent any

    stages {
        stage('Récupération du git') {
            steps {
                git url: 'https://github.com/feriel-belhaj/ferielammar4sleam1.git', branch: 'main'
            }
        }

        stage('Lancer les tests unitaires') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Création du livrable') {
            steps {
                sh 'mvn package'
            }
        }
    }

    post {
        success {
            echo 'Pipeline réussi ! Le .jar est généré dans target/'
        }
        failure {
            echo 'Échec du pipeline'
        }
    }
}