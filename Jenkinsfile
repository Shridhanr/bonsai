pipeline {

  environment {
    dockerimagename = "shridhanr/ubuntu"
    dockerImage = ""
  }

  agent any

  stages {

    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }

    stage('Pushing Image') {
      environment {
               registryCredential = 'dockerhublogin'
           }
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push("latest")
          }
        }
      }
    }
    stage('Check Cluster') {
      steps{
       script {
            sh 'export PATH=$PATH:/home/ubuntu/.kube/config'
            //sh 'sudo export KUBECONFIG=/home/ubuntu/.kube/config'
            //sh 'mkdir .kube && cat $KUBECONFIG > .kube/config'
            sh "sudo kubectl apply -f deploymentservice.yml -S"
            sh "echo 'deployment completed successfully'"
            }
      }
    }
  }

}
