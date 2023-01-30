pipeline {

    environment {
        APP_NAME = "web-de-thompson" 
   //   Jenkins tiene 2 tipos de variable de entorno, internas y externas. 
   //   Las internas son las que definimos nostros mismos dentro del jenkinsfile, dentro de enviroment,como por ej: REGISTRY y PASS
   //   Las externas son las que Jenkins nos permitie traernos desde afuera del Jenkinsfile, como por ej: BUILD_NUMBER y GIT_URL
   //   Antes, insertabamos la variable externa BUILD_NUMBER dentro de la var interna APP_TAG. Esto lo haciamos porque nosotros utilizamos el BUILD_NUMBER 
   //   Jenkins para usar el APP_TAG de la version de la imagen. Pero podriamos usar directamente la var BUILD_NUMER sin convertirla en una var interna APP_TAG
   //   APP_TAG = "${BUILD_NUMBER}"
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
        
        stage('test variables de entorno') {
            steps { 
                sh "echo $GIT_URL"
                sh "echo ${GIT_URL}"
            }
        }  

        stage('Clonar repo de aplicacion ferrari') {
            steps { 
                git branch: 'main', changelog: false, poll: false, url: '$GIT_URL'
            }
        }        
         stage('buildear imagen') {
            steps {
                sh "docker build -t $REGISTRY/$APP_NAME:$BUILD_NUMBER ."
            }
        }
        stage('docker push') {
            steps {
                sh "docker login -u $REGISTRY -p $PASS"
                sh "docker push $REGISTRY/$APP_NAME:$BUILD_NUMBER "
                
            }
        }        

    } 
  }
