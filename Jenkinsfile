pipeline {
    agent {
       kubernetes {
           yaml """
apiVersion: v1 
kind: Pod 
metadata: 
    name: img 
    annotations:
      container.apparmor.security.beta.kubernetes.io/img: unconfined
      container.seccomp.security.alpha.kubernetes.io/img: unconfined
spec: 
    containers: 
      - name: img
        image: sysdiglabs/img
        command: ['cat']
        tty: true
"""
       }
   }

    parameters { 
        string(name: 'DOCKER_REPOSITORY', defaultValue: 'sysdigcicd/cronagent', description: 'Name of the image to be built (e.g.: sysdiglabs/dummy-vuln-app)') 
    }
    
    environment {
        DOCKER = credentials('docker-repository-credentials')
    }
    
    stages {
        stage('Checkout') {
            steps {
                container("img") {
                    checkout scm
                }
            }
        }
        stage('Build Image') {
            steps {
                container("img") {
                    sh "img build -f Dockerfile -t ${params.DOCKER_REPOSITORY} ."
                }
            }
        }
        stage('Push Image') {
            steps {
                container("img") {
                    sh "img login -u ${DOCKER_USR} -p ${DOCKER_PSW}"
                    sh "img push ${params.DOCKER_REPOSITORY}"
                    sh "echo ${params.DOCKER_REPOSITORY} > sysdig_secure_images"
                }
            }
        }
        stage('Scanning Image') {
            steps {
                sysdigSecure engineCredentialsId: 'sysdig-secure-api-credentials', name: 'sysdig_secure_images'
            }
        }
   }
}
