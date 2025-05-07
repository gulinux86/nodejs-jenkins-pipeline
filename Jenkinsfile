pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'meu-app-node'
        DOCKER_TAG = "${BUILD_ID}"
        REGISTRY_CREDENTIALS = 'dockerhub-credentials-id'
        DOCKER_REGISTRY = 'docker.io/gustpn'
    }

    parameters {
        choice(name: 'Escolha_o_ambiente', choices: ['HML', 'PRD', 'TEST'], description: 'Escolha o ambiente para deploy')
    }

    stages {
        stage('Clear workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                sh 'git clone https://github.com/gulinux86/nodejs-jenkins-pipeline.git .'
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Tests') {
            steps {
                script {
                    try {
                        sh 'npm run test' 
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }

        stage('Build Docker') {
            steps {
                sh """
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker images
                """
            }
        }

        // Push to HML
        stage('Push Docker - HML') {
            when {
                expression { return params.Escolha_o_ambiente == 'HML' }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker login -u "$DOCKER_USER" -p "${DOCKER_PASS}" docker.io
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}-${params.Escolha_o_ambiente}
                        docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}-${params.Escolha_o_ambiente}
                    """
                }
            }
        }

        // Push to PRD
        stage('Push Docker - PRD') {
            when {
                expression { return params.Escolha_o_ambiente == 'PRD' }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker login -u "$DOCKER_USER" -p "${DOCKER_PASS}" docker.io
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}-${params.Escolha_o_ambiente}
                        docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}-${params.Escolha_o_ambiente}
                    """
                }
            }
        }

        // Push to TEST
        stage('Push Docker - TEST') {
            when {
                expression { return params.Escolha_o_ambiente == 'TEST' }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker login -u "$DOCKER_USER" -p "${DOCKER_PASS}" docker.io
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}-${params.Escolha_o_ambiente}
                        docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}-${params.Escolha_o_ambiente}
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo "Pipeline finished successfully! Image: ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
