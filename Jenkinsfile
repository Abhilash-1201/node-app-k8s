pipeline {
    agent any
    environment {
       DOCKER_TAG = getDockerTag()
    }
    stages{
        stage("Build Dokcer Image") {
            steps {
                sh "docker build . -t abhilashnarayan/javaapp:${DOCKER_TAG}"
            }
        }

        stage ('Docker Image Push') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-id', variable: 'dockerhubpwd')]) {
                    sh "docker login -u abhilashnarayan -p ${dockerhubpwd}"
                    sh "docker push abhilashnarayan/javaapp:${DOCKER_TAG}"
                }
                
            }
        }

        stage ('Deploy To K8S') {
            steps {
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sshagent(['K8S']) {
                 // some block
                    sh "scp -o StrictHostKeyChecking=no services.yml java-app-pod.yml ubuntu@18.144.161.205:/home/ubuntu/"
                    script{
                        try{
                            sh "ssh ubuntu@18.144.161.205 kubectl apply -f ."
                        }catch(error){
                            sh "ssh ubuntu@18.144.161.205 kubectl create -f ."
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
