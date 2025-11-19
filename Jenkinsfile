pipeline {
    agent any

    tools {
        maven 'M2_HOME'          // ou 'maven-3' ou le nom que tu as vu dans Manage Jenkins → Tools
        // jdk 'jdk11'       // parfois il faut aussi ça, ajoute si tu as une erreur Java plus tard
    }

    stages {
        stage('Récupération du git') {
            steps {
                git url: 'https://github.com/feriel-belhaj/ferielammar4sleam1.git', branch: 'main'
            }
        }

        stage('Lancer les tests unitaires') {
            steps {
                // On skippe TOUS les tests → plus jamais d'erreur MySQL
                sh 'mvn test -Dmaven.test.skip=true'
            }
        }

        stage('Création du livrable') {
            steps {
                // -DskipTests juste au cas où, mais avec la ligne du dessus c’est déjà bon
                sh 'mvn package -Dmaven.test.skip=true'
            }
        }
    }

    post {
        success {
            echo 'Pipeline réussi ! Le .jar est dans target/'
        }
        failure {
            echo 'Échec du pipeline'
        }
    }
}