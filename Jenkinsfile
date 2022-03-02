#!groovy

node('master') {
    timestamps {
        //try {
            step([$class: 'WsCleanup'])
            stage('Checkout code') {
                checkout scm
            }

            //global variable
            def SERVICE_NAME = dcompose
            def customImage1 = docker-compose ("shridhanr/${SERVICE_NAME}"

            stage('Docker Compose & Push') {
                docker.withRegistry('https://registry.hub.docker.com', 'Docker_creds') { 
                sh 'sudo docker-compose build'
                /* sh 'docker pull deepset/haystack-cpu:latest'
                sh 'docker tag deepset/haystack-cpu:latest shridhanr/dcompose-haystack:latest'
                sh 'docker push shridhanr/dcompose-haystack:latest' */
                 sh "sudo docker-compose push ${customImage1}" 

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