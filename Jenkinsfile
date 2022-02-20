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
                /*docker.withRegistry('https://registry.hub.docker.com', 'Docker_creds') */
                withCredentials([string(credentialsId: '4710ad4f-2401-4a57-b9d0-7ff395aefad5', variable: 'PAT')]) {
                def customImage1 = docker.build("shridhanr/${SERVICE_NAME}-main", "--build-arg GIT_PAT=${PAT} -f ${dockerfile1} .")
                def customImage2 = docker.build("shridhanr/${SERVICE_NAME}-action", "--build-arg GIT_PAT=${PAT} -f ${dockerfile1} .")
                   /* Push the image to the custom Registry */
                customImage1.push("${env.BUILD_ID}")
                customImage1.push('latest')
                customImage2.push("${env.BUILD_ID}")
                customImage2.push('latest')
                }
            }

            stage('Deployment') {
                def k8sImage = docker.image('shridhanr/kubectl-git')
                k8sImage.inside("-u 0:0 --entrypoint=''") {
                    //adding kubeconfig file to docker container for k8 deployment
                    withCredentials([file(credentialsId: 'kubernetes', variable: 'KUBECONFIG')]) {
                        sh 'mkdir .kube && cat $KUBECONFIG > .kube/config'
                       // sh "kubectl -n app create configmap ${SERVICE_NAME}-dev-config --from-file=config/dev.yaml -o yaml --dry-run=client | kubectl apply -f -"
                        sh 'chmod +x K8s_Objects/deploy.sh'
                        sh "K8s_Objects/deploy.sh ${env.BUILD_ID} ${SERVICE_NAME}"
                        sh "echo 'deployment completed successfully'"
                        }
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
