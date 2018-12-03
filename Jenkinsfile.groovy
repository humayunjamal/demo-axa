pipeline {
  agent any
  options {
    disableConcurrentBuilds()
  }
  stages {
    stage('Start') {
      steps {
        slackSend(color: '#FFFF00', message: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
    }
    stage('CREATE TEMP ENV') {
      steps {
        sh "echo Creating local ENVIRONMENT for testing"
        sh "sleep 5"

  }
    }
    stage('RUN  UNIT TESTS') {

      steps {
        sh "echo RUNNING UNIT TESTS against local TEMP ENVIRONMENT"
        sh "sleep 5"

      }
      
    }
    

   
    stage('CREATE UAT ENVIRONMENT') {    
      steps {
        echo "Running Terraform to create UAT ENVIRONMENT"
        echo "Starting deployment on ENVIRONMENT ${deploy}"
        sh """
        cd terraform/staging/service/ecs-demo-service-uat
        terraform init 
        terraform apply -auto-approve
        """
        echo "Starting deployment on UAT ENVIRONMENT"
        sh """
        ecs-deploy -c Demo-Cluster -n ecs-demo-service-uat -to latest -i ecs-demo-service-uat -t 300 
        """

      }
    }
     stage('DEPLOY TO PROD') {
   
      steps {
        echo "Starting deployment on Prod"
        sh """
        pwd
        ls -ltrh
        """
      }
    }
    
  }
}

