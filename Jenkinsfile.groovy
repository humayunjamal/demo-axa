pipeline {
    agent any
    options {
        disableConcurrentBuilds()
    }
    stages {
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
                sh """
        pwd
        sleep 5
        """

            }
        }

        stage('DEPLOY TO UAT ENVIRONMENT') {
            steps {
                echo "Starting deployment on UAT ENVIRONMENT"
                sh """
                ./deploy_uat.sh
        """

            }
        }

        stage('TESTING UAT ENVIRONMENT') {
            steps {
                echo "Starting UAT ENVIRONMENT TESTS"
                sh "sleep 5"
                sh "bash -x ./test/demo.sh"

            }
        }

        stage('DEPLOY TO PROD') {

            steps {
                echo "Starting deployment on Prod"
                sh """
        pwd
        ls -ltrh
        ./deploy.sh

        """
            }
        }

    }
    post {
    success {

         echo "success"
      
    }

    failure {
        echo "failure"
      
    }
   cleanup{
        deleteDir()
    }

  }
}

