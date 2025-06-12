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

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withDockerRegistry(credentialsId: "${DOCKER_CREDENTIALS_ID}", url: '') {
                    script {
                        docker.image("${IMAGE_NAME}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
    }

    triggers {
        githubPush()
    }
}
