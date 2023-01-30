pipeline {

    environment {
        APP_NAME = "web-de-thompson"
        APP_TAG = "${BUILD_NUMBER}"
        REGISTRY = "martooo"
        PASS = "arquitectura123"
    }

    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: slave
  name: agent-pod
spec:
  containers:
  - name: agent-container
    image: tferrari92/jenkins-inbound-agent-git-npm-docker
    command:
    - sleep
    args:
    - "99"
    env:
    resources:
      limits: {}
      requests:
        memory: "256Mi"
        cpu: "100m"
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: volume-0
      readOnly: false
    - mountPath: /home/jenkins/agent
      name: workspace-volume
      readOnly: false
  hostNetwork: false
  nodeSelector:
    kubernetes.io/os: "linux"
  restartPolicy: Never
  volumes:
  - emptyDir:
      medium: ""
    name: workspace-volume
  - hostPath:
      path: /var/run/docker.sock
    name: volume-0
'''
            defaultContainer 'agent-container'
        }
    }
  
    stages {

        stage('Clonar repo de aplicacion ferrari') {
            steps { 
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/martinsendati/repo-de-app-ferrari.git'
            }
        }        
         stage('buildear imagen') {
            steps {
                sh "docker build -t $REGISTRY/$APP_NAME:$APP_TAG ."
            }
        }
        stage('docker push') {
            steps {
                sh "docker login -u $REGISTRY -p $PASS"
                sh "docker push $REGISTRY/$APP_NAME:$APP_TAG "
                
            }
        }        

    } 
  }
