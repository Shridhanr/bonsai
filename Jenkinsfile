#!groovy

node('master') {
    timestamps {
        //try {
            step([$class: 'WsCleanup'])
            stage('Checkout code') {
                checkout scm
            }

            //global variable
            def SERVICE_NAME = sh(returnStdout: true, script: "git config --get remote.origin.url | cut -f 5 -d '/' | sed 's/.git//g'").trim()
           

            stage('Docker Build & Push') {
                docker.withRegistry('https://registry.hub.docker.com', 'Docker_creds') { 
                //def customImage1 = docker.build("shridhanr/${SERVICE_NAME}-rasaactions", "-f ${dockerfile1} .")
                docker-compose build
                docker-compose push

                }
            } 

            stage('Deployment') {
                def k8sImage = docker.image('shridhanr/dcompose')
                k8sImage.inside("-u 0:0 --entrypoint=''") {
                    //sh 'chmod +x K8s_Objects/deploy.sh'
                    kubernetesDeploy(configs: "deployment.yaml", kubeconfigId: "kubernetes")
                    sh "echo 'deployment completed successfully'"
                    }
                }
    }
        /*catch (CaughtErr) {
            currentBuild.result = "FAILED"
            println("Caught exception: " + CaughtErr)
            // error = catchException exception: CaughtErr
            } 
        /*finally {
            println("CurrentBuild result: " + currentBuild.result)
            // Success or failure, always send notifications
            notifyBuild(currentBuild.result)
            }
        }*/
}