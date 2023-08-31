pipeline {
  options {
    buildDiscarder(logRotator(numToKeepStr: '3', artifactNumToKeepStr: '3'))
  }
  environment {
    IMAGE_NAME = "ic-webapp"
    IMAGE_TAG = "latest"
    APP_CONTAINER_PORT = "8080"
    DOCKERHUB_ID = "mnberthe"
    DOCKERHUB_PASSWORD = credentials('dockerhub_password')
    APP_CONTAINER_PORT = "8080"
    APP_EXPOSED_PORT = "9090"
  }
  agent any
    stages {
      stage('Build image'){
        steps {
          script {
            sh 'docker build -t $DOCKERHUB_ID/$IMAGE_NAME:$IMAGE_TAG -f app/Dockerfile .'
          }
        }
      }

      stage('Run container based on builded image') {  
        agent any
        steps {
          script {
            sh '''
                echo "Cleaning existing container if exist"
                docker ps -a | grep -i $IMAGE_NAME && docker rm -f $IMAGE_NAME
                docker run  --name $IMAGE_NAME  -d -p $APP_EXPOSED_PORT:$APP_CONTAINER_PORT ${DOCKERHUB_ID}/$IMAGE_NAME:$IMAGE_TAG
                sleep 5
            '''
          }
        }
      }
    
  }
}