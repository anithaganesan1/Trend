pipeline {
    agent any

    environment {
        IMAGE_NAME = 'aniganesan/trend:latest'
        DOCKER_CREDENTIALS_ID = 'dockerhub-id'
    }

    stages {
        stage('Checkout Code') {
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
                withDockerRegistry(credentialsId: "${DOCKER_CREDENTIALS_ID}", url: "https://index.docker.io/v1/") {
                        docker.image("${IMAGE_NAME}").push()
                    }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                //sh 'kubectl apply -f k8s/'
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yml'
            }
        }
    }
}
