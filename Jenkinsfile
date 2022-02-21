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
            def dockerfile1 = 'backend/Dockerfile.main'
            def dockerfile2 = 'actions/Dockerfile.action'

            stage('Docker Build & Push') {
                docker.withRegistry('https://registry.hub.docker.com', 'Docker_creds') { 
                def customImage1 = docker.build("shridhanr/${SERVICE_NAME}-main", "-f ${dockerfile1} .")
                def customImage2 = docker.build("shridhanr/${SERVICE_NAME}-action", "-f ${dockerfile2} .")
                customImage1.push("${env.BUILD_ID}")
                customImage1.push('latest')
                customImage2.push("${env.BUILD_ID}")
                customImage2.push('latest')
                }
            }
            stage('Deployment') {
                def k8sImage = docker.image('shridhanr/bonsai-main')
                k8sImage.inside("-u 0:0 --entrypoint=''") {
                    sh 'chmod +x K8s_Objects/deploy.sh'
                    kubernetesDeploy(configs: "deployment.yaml", kubeconfigId: "kubernetes")
                        sh "K8s_Objects/deploy.sh ${env.BUILD_ID} ${SERVICE_NAME}"*/
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
