#!groovy

node('master') {
    timestamps {
        try {
            step([$class: 'WsCleanup'])
            stage('Checkout code') {
                checkout scm
            }

            //global variable
            def SERVICE_NAME = sh(returnStdout: true, script: "git config --get remote.origin.url | cut -f 5 -d '/' | sed 's/.git//g'").trim()
           

            stage('Docker Compose & Push') {
                docker.withRegistry('https://registry.hub.docker.com', 'Docker_creds') { 
                //def customImage1 = docker.build("shridhanr/${SERVICE_NAME}-rasaactions", "-f ${dockerfile1} .")
                sh "sudo docker-compose build"
                sh 'sudo docker-compose push'

                }
            } 

            stage('Deployment') {
                def k8sImage = docker.image('shridhanr/haystack_ui')
                k8sImage.inside("-u 0:0 --entrypoint=''") {
                    //sh 'chmod +x K8s_Objects/deploy.sh'
                    kubernetesDeploy(configs: "deployment.yaml", kubeconfigId: "kubernetes")
                    sh "echo 'deployment completed successfully'"
                    }
            }
        }
        catch (CaughtErr) {
            currentBuild.result = "FAILED"
            println("Caught exception: " + CaughtErr)
            // error = catchException exception: CaughtErr
            } 
        finally {
            println("CurrentBuild result: " + currentBuild.result)
            // Success or failure, always send notifications
            notifyBuild(currentBuild.result)
            }
    }
}
def notifyBuild(String buildStatus = 'STARTED') {
  // build status of null means successful
  buildStatus =  buildStatus ?: 'SUCCESS'

  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = "${subject} (${env.BUILD_URL})"

  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESS') {
    color = 'GREEN'
    colorCode = '#00FF00'
  } else {
    color = 'RED'
    colorCode = '#FF0000'
  }

  // Send notifications
  //slackSend (color: colorCode, message: summary)
}