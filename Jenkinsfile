pipeline {
    agent any
    environment {
       DOCKER_TAG = getDockerTag()
    }
    stages{
        stage("Build Dokcer Image") {
            steps {
                sh "docker build . -t abhilashnarayan/nodeapp:${DOCKER_TAG}"
            }
        }

        stage ('Docker Image Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPwd')]) {
                    sh "docker login -u abhilashnarayan -p ${dockerHubPwd}"
                    sh "docker push abhilashnarayan/nodeapp:${DOCKER_TAG}"
                }
                
            }
        }

        stage ('Deploy To K8S') {
            steps {
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sshagent(['kops-machine']) {
                 // some block
                    sh "scp -o StrictHostKeyChecking=no services.yml node-app-pod.yml ubuntu@184.169.230.218:/home/ubuntu/"
                    script{
                        try{
                            sh "ssh ubuntu@184.169.230.218 kubectl apply -f ."
                        }catch(error){
                            sh "ssh ubuntu@184.169.230.218 kubectl create -f ."
                        }
                    }
            }
            }

        }
        
    }

}
def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
