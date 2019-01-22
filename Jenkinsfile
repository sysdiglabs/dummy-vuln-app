node {
    stage('Checkout') {
        checkout scm
    }
    stage('Build Image') {
        withCredentials([string(credentialsId: 'docker-repository-name', variable: 'DOCKER_REPOSITORY')]) {
            sh 'sudo docker build -f Dockerfile -t ${DOCKER_REPOSITORY} .'
        }
    }
    stage('Push Image') {
        withCredentials([usernamePassword(credentialsId: 'docker-repository-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME'),
                         string(credentialsId: 'docker-repository-name', variable: 'DOCKER_REPOSITORY')]) {
            sh '''
                sudo docker login --username ${DOCKER_USERNAME} --password ${DOCKER_PASSWORD}
                sudo docker push ${DOCKER_REPOSITORY}
                echo docker.io/${DOCKER_REPOSITORY} > sysdig_secure_images
            '''
        }
    }
    stage('Scanning Image') {
        anchore 'sysdig_secure_images'
    }
}
