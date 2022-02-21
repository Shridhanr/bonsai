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

            /* stage('Docker Build & Push') {
                docker.withRegistry('https://registry.hub.docker.com', 'Docker_creds') { 
                def customImage1 = docker.build("shridhanr/${SERVICE_NAME}-main", "-f ${dockerfile1} .")
                def customImage2 = docker.build("shridhanr/${SERVICE_NAME}-action", "-f ${dockerfile2} .")
                customImage1.push("${env.BUILD_ID}")
                customImage1.push('latest')
                customImage2.push("${env.BUILD_ID}")
                customImage2.push('latest')
                }
            } */

            stage('Deployment') {
                def k8sImage = docker.image('shridhanr/bonsai-main')
                k8sImage.inside("-u 0:0 --entrypoint=''") {
                    sh 'chmod +x K8s_Objects/deploy.sh'
                    //adding kubeconfig file to docker container for k8 deployment
                    //withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                        //sh 'mkdir .kube && cat $KUBECONFIG > .kube/config'
                    kubernetesDeploy(configs: "deployment.yaml", kubeconfigId: "kubernetes")
                       // sh "kubectl -n app create configmap ${SERVICE_NAME}-dev-config --from-file=config/dev.yaml -o yaml --dry-run=client | kubectl apply -f -"
                        /*sh 'export KUBECONFIG=${WORKSPACE}/.kube/config'
                        //sh 'export PATH=$PATH:/usr/local/bin:$KUBECONFIG'
                        //sh 'kubetl get nodes --kubeconfig=${WORKSPACE}/.kube/config'
                        sh 'curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.22.2/bin/linux/amd64/kubectl"' 
                        sh 'chmod u+x ./kubectl' 
                        //Install AWS IAM Authenticator Binary
                        sh 'curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator'
                        sh 'chmod +x ./aws-iam-authenticator'
                        sh 'mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin'
                        sh './kubectl get nodes'
                        
                        
                        sh "K8s_Objects/deploy.sh ${env.BUILD_ID} ${SERVICE_NAME}"*/
                        sh "echo 'deployment completed successfully'"
                        //}
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
