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
    /*stage('Deploying App to Kubernetes') {
      steps {
        script {
          kubernetesDeploy(configs: "deploymentservice.yml", kubeconfigId: "kubernetes")
        }
      }
    }*/
   stage('Apply Kubernetes files') {
    steps  {
      withKubeConfig([credentialsId: 'kubernetes', serverUrl: 'https://3.86.119.88:6443']) {
      sh 'kubectl apply -f deploymentservice.yml'
     }
    }
   }
  }

}
