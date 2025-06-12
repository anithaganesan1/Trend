pipeline {
    agent any

    environment {
        IMAGE_NAME = 'aniganesan/trend:latest'
        DOCKER_CREDENTIALS_ID = 'dockerhub-id'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build Vite App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withDockerRegistry(credentialsId: "${DOCKER_CREDENTIALS_ID}") {
                    script {
                        docker.image("${IMAGE_NAME}").push()
                    }
                }
            }
        }
    }
}

