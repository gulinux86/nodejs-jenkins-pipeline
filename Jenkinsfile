    pipeline {
        agent {
        docker {
        image 'gustpn/devops_tools:v11_tools'
        args '-u 0:0'
        args '-v $HOME:/root --network jenkins-sonar-network'
        }
    }

    environment {
        DOCKER_IMAGE = 'meu-app-node'
        DOCKER_TAG = "${BUILD_ID}"
        REGISTRY_CREDENTIALS = 'dockerhub-credentials-id'
        DOCKER_REGISTRY = 'docker.io/gustpn'
        SONAR_CREDENTIAL_ID = 'squ_4719b8cb6410f09d6bb571eed759107bb056b1ca' 
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

        stage('Tool Versions') {
            steps {
                sh '''
                    echo "===> kubectl version"
                    kubectl version --client=true || echo "kubectl not found"

                    echo "===> ansible version"
                    ansible --version | head -n1 || echo "ansible not found"

                    echo "===> terraform version"
                    terraform version || echo "terraform not found"

                    echo "===> aws cli version"
                    aws --version || echo "aws CLI not found"

                    echo "===> helm version"
                    helm version --short || echo "helm not found"
                '''
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

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv('SonarQube-Server') {
                sh '''
                    sonar-scanner \
                    -Dsonar.projectKey=node-app \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://172.21.0.2:9000           
               '''
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
