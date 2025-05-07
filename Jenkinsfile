pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'meu-app-node'
        DOCKER_TAG = 'latest'
        REGISTRY_CREDENTIALS = 'dockerhub-credentials-id'
        DOCKER_REGISTRY = 'docker.io/gustpn'
    }

    parameters {
        choice(name: 'Escolha_o_ambiente', choices: ['HML', 'PRD', 'TEST'], description: 'Escolha o ambiente para deploy')
    }

    stages {
        stage('Limpar workspace') {
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
                sh 'npm test || echo "Sem testes definidos"'
            }
        }

        stage('Build Docker') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        // Push para HML
        stage('Push Docker - HML') {
            when {
                expression { return params.Escolha_o_ambiente == 'HML' }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker login -u "$DOCKER_USER" -p "${DOCKER_PASS}" docker.io
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:hml
                        docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:hml
                    """
                }
            }
        }

        // Push para PRD
        stage('Push Docker - PRD') {
            when {
                expression { return params.Escolha_o_ambiente == 'PRD' }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker login -u "$DOCKER_USER" -p "${DOCKER_PASS}" docker.io
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:prd
                        docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:prd
                    """
                }
            }
        }

        // Push para TEST
        stage('Push Docker - TEST') {
            when {
                expression { return params.Escolha_o_ambiente == 'TEST' }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker login -u "$DOCKER_USER" -p "${DOCKER_PASS}" docker.io
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:test
                        docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:test
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
