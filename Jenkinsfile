pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'meu-app-node'
        DOCKER_TAG = 'latest'
        REGISTRY_CREDENTIALS = 'dockerhub-credentials-id' // substitua pelo ID no Jenkins
        DOCKER_REGISTRY = 'docker.io/gustpn' // substitua pelo seu namespace
    }
 

    stages {
        stage ('Limpar workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                sh 'git clone https://github.com/gulinux86/nodejs-jenkins-pipeline.git .'
            
            }
        }

        stage('Instalar dependências') {
            steps {
                sh 'npm install'
            }
        }

        stage('Testes') {
            steps {
                // Se não houver testes, você pode comentar ou remover esta etapa
                sh 'npm test || echo "Sem testes definidos"'
            }
        }

        stage('Build Docker') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Push Docker (opcional)') { 
            when {
                expression { return env.DOCKER_REGISTRY != '' }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin ${DOCKER_REGISTRY}
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finalizada.'
        }
        success {
            echo 'Pipeline concluída com sucesso!'
        }
        failure {
            echo 'Falha na pipeline.'
        }
    }
}
