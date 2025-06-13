pipeline {
    agent any

    environment {
        IMAGE_NAME = 'aniganesan/trend:latest'
        DOCKER_CREDENTIALS_ID = 'dockerhub-id'
        DOCKER_REGISTRY = 'https://index.docker.io/v1/'
        CLUSTER_NAME = 'trend-cluster'
        AWS_REGION = 'ap-south-1'
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
                script {
                    withDockerRegistry([credentialsId: "${DOCKER_CREDENTIALS_ID}", url: "${DOCKER_REGISTRY}"]) {
                        docker.image("${IMAGE_NAME}").push()
                    }
                }
            }
        }

        stage('Configure kubeconfig') {
            steps {
                script {
                    // Set up kubeconfig for the EKS cluster
                    sh "aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml --validate=false'
                sh 'kubectl apply -f service.yml --validate=false'
            }
        }
    }

    post {
        success {
            echo '✅ Application deployed successfully!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}
