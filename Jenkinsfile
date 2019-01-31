pipeline {
    agent any
    parameters {
        string(name: 'DOCKER_REPOSITORY', description: 'Docker image name', defaultValue: '')
    }
    environment {
        DOCKER = credentials('docker-repository-credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Image') {
            steps {
                sh "sudo docker build -f Dockerfile -t ${params.DOCKER_REPOSITORY} ."
            }
        }
        stage('Push Image') {
            steps {
                sh "sudo docker login --username ${DOCKER_USR} --password ${DOCKER_PSW}"
                sh "sudo docker push ${params.DOCKER_REPOSITORY}"
                sh "echo docker.io/${params.DOCKER_REPOSITORY} > sysdig_secure_images"
            }
        }
        stage('Scanning Image') {
            steps {
                anchore 'sysdig_secure_images'
            }
        }
   }
}
