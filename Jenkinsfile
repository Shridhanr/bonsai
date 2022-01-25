pipeline {

  environment {
    dockerimagename = "shridhanr/ubuntu"
    dockerImage = ""
  }

  agent any
  step([$class: 'WsCleanup'])
        stage('Checkout code') {
            checkout scm
    }
  //global variable
            def SERVICE_NAME = sh(returnStdout: true, script: "git config --get remote.origin.url | cut -f 5 -d '/' | sed 's/.git//g'").trim()
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
      withCredentials([file(credentialsId: 'kubernetes', variable: 'KUBECONFIG')]) {
                        sh 'mkdir .kube && cat $KUBECONFIG > .kube/config'
                        // sh "kubectl -n app create configmap ${SERVICE_NAME}-dev-config --from-file=config/dev.yaml -o yaml --dry-run=client | kubectl apply -f -"
                        sh 'chmod +x deploy.sh'
                        sh "deploy.sh ${env.BUILD_ID} ${SERVICE_NAME}"
                        sh "echo 'deployment completed successfully'"
                        }
    }
    stage('Deploying App to Kubernetes') {
      steps {
        script {
          kubernetesDeploy(configs: "deploymentservice.yml", kubeconfigId: "kubernetes")
        }
      }
    }

  }

}
