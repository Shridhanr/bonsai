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
    //global variable
    def SERVICE_NAME = bonsai_test
    steps  {
      withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
          //sh 'mkdir .kube && cat $KUBECONFIG > .kube/config'
          // sh "kubectl -n app create configmap ${SERVICE_NAME}-dev-config --from-file=config/dev.yaml -o yaml --dry-run=client | kubectl apply -f -"
          sh 'chmod +x deploy.sh'
          sh "deploy.sh ${env.BUILD_ID} ${SERVICE_NAME}"
          sh "echo 'deployment completed successfully'"
          }
      /*withKubeConfig([credentialsId: 'kubeconfig', serverUrl: 'https://3.86.119.88:6443']) {
      //sh 'curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator'
      //sh 'chmod +x ./aws-iam-authenticator'
      //sh 'mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin'
      //sh "echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc"
      //sh 'aws-iam-authenticator help'
      //sh 'export PATH=$PATH:/home/ubuntu/.kube/config'
      //sh 'kubectl apply -f deploymentservice.yml'
     }*/
    }
   }
  }

}
