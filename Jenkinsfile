pipeline {
    agent any

    environment {
        IMAGE_NAME = 'aniganesan/trend:latest'
        DOCKER_CREDENTIALS_ID = 'dockerhub-id'
        KUBECONFIG_CREDENTIALS_ID = 'kubeconfig-id'  // optional, if using kubeconfig
    }

    triggers {
        githubPush()
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
                // Optional: if using KUBECONFIG from Jenkins credentials
                // withCredentials([file(credentialsId: "${KUBECONFIG_CREDENTIALS_ID}", variable: 'KUBECONFIG')]) {
                //     sh 'kubectl apply -f deployment.yaml'
                //     sh 'kubectl apply -f service.yml'
                // }

                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yml'
            }
        }
    }
}
