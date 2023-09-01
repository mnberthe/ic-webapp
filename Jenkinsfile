pipeline {
  options {
    buildDiscarder(logRotator(numToKeepStr: '3', artifactNumToKeepStr: '3'))
  }
  environment {
    IMAGE_NAME = "ic-webapp"
    IMAGE_TAG = "latest"
    DOCKERHUB_ID = "mnberthe"
    DOCKERHUB_CREDENTIALS = credentials('DOCKERHUB_PASSWORD')
    APP_CONTAINER_PORT = "8080"
    APP_EXPOSED_PORT = "9090"
    HOST_IP = "15.188.105.8"
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

      stage('Test image') {
           steps {
              script {
                sh '''
                   curl -I http://${HOST_IP}:${APP_EXPOSED_PORT} | grep -i "200"
                '''
              }
           }
       }

      stage('Clean container') {
        steps {
          script {
            sh '''
                docker stop $IMAGE_NAME
                docker rm $IMAGE_NAME
            '''
          }
        }
     }

      stage ('Login and Push Image on docker hub') {
        steps {
          script {
            sh ''' 
                docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW
                docker push ${DOCKERHUB_ID}/$IMAGE_NAME:$IMAGE_TAG
            '''
          }
        }
      }

      stage ('Build EC2 on Dev ') {
        agent { 
            docker { 
                    image 'jenkins/jnlp-agent-terraform'  
            } 
        }
        environment {
          TF_IN_AUTOMATION = 'true'
          AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
          AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        } 
        when {
            branch 'dev'
        }
        steps {
          script {
            sh ''' 
               cd "./terraform"
               terraform init -no-color 
               terraform plan -no-color  -var-file="dev.tfvars"
               terraform apply --auto-approve -var-file="dev.tfvars"
            '''
          }
        }
      }

      stage ('Build EC2 on Prod ') {
        agent { 
            docker { 
                    image 'jenkins/jnlp-agent-terraform'  
            } 
        }
        environment {
          TF_IN_AUTOMATION = 'true'
          AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
          AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        } 
        when {
            branch 'master'
        }
        steps {
          script {
            sh ''' 
               cd "./terraform"
               terraform init -no-color 
               terraform plan -no-color  -var-file="prod.tfvars"
               terraform apply --auto-approve -var-file="prod.tfvars"
            '''
          }
        }
      }

      stage('Validate Destroy') {
        input {
          message "Do you want to destroy?"
          ok "Destroy"
        }
        steps {
          echo 'Destroy Approved'
        }
      }

      stage('Destroy'){
        steps {
           script {
              if (env.BRANCH_NAME == 'dev') {
                  sh 'terraform destroy -auto-approve  -no-color -var-file="dev.tfvars"'
              } else if (env.BRANCH_NAME == 'prod'){
                  sh 'terraform destroy -auto-approve  -no-color -var-file="prod.tfvars"'
              } else {
                   echo 'no env found'
              }
           }
        }
      }
    
  }
}