pipeline {
 environment {
    IMAGE_NAME="ic-webapp"
    IMAGE_TAG = "latest"
    STAGING = "ic-webapp-mb-staging"
    PRODUCTION="ic-webapp-mb-prod"
    DOCKERHUB_ID = "mnberthe"
    INTERNAL_PORT = "8080"
    EXTERNAL_PORT = "9090"
    CONTAINER_IMAGE = "${DOCKERHUB_ID}/${IMAGE_NAME}:${IMAGE_TAG}"
    ODOO_URL= "https://www.odoo.com/"
    PGADMIN_URL= "https://www.pgadmin.org/"
 }
 agent any
  stages {
    stage('Build image'){
      agent any
      steps {
        script {
          sh 'docker build -t $DOCKERHUB_ID/$IMAGE_NAME:$IMAGE_TAG -f app/Dockerfile .'
        }
      }
    }
  }
}