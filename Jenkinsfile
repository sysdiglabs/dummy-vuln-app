pipeline {
    agent {
       kubernetes {
           yaml """
apiVersion: v1 
kind: Pod 
metadata: 
    name: dind
    annotations:
      container.apparmor.security.beta.kubernetes.io/dind: unconfined
      container.seccomp.security.alpha.kubernetes.io/dind: unconfined
spec: 
    containers: 
      - name: dind
        image: docker:dind
        securityContext:
          privileged: true
        tty: true
        volumeMounts:
        - name: var-run
          mountPath: /var/run
      - name: jnlp
        image: jenkins/inbound-agent:4.6-1
        
    volumes:
    - emptyDir: {}
      name: var-run
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
                container("dind") {
                    checkout scm
                }
            }
        }
        stage('Build Image') {
            steps {
                container("dind") {
                    sh "docker build -f Dockerfile -t ${params.DOCKER_REPOSITORY} ."
                }
            }
        }
        stage('Scanning Image Prep') {
            steps {
                 container("jnlp") {
                     sh '''
                         curl -LO "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/$(curl -L -s https://download.sysdig.com/scanning/sysdig-cli-scanner/latest_version.txt)/linux/amd64/sysdig-cli-scanner"
                         chmod +x ./sysdig-cli-scanner
                     '''
                }
            }
        }
        stage('Scanning Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'sysdig-secure-api-credentials', passwordVariable: 'SECURE_API_TOKEN', usernameVariable: '')]) {
                    container("dind") {
                        sh "./sysdig-cli-scanner --apiurl https://secure.sysdig.com ${params.DOCKER_REPOSITORY}  --policy sysdig-best-practices -u --detailed-policies-eval"
                    }
                }
            }
        }
   }
}
