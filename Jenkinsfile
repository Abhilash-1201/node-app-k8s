pipeline {
    agent any
    environment{
        DOCKER_TAG = getDockerTag()    
    }
    stages{
        stage('Build Docker Image'){
            steps{
                sh "docker build . -t abhilashnarayan/nodeapp:${DOCKER_TAG}"
            }
        }
        stage('DockerHub Push'){
            steps{
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerhub-id')]) {
                    sh "docker login -u abhilashnarayan -p ${dockerhub-id}"
                    sh "docker push abhilashnarayan/nodeapp:${DOCKER_TAG}"
                }
            }
        }
        stage('Docker Deploy k8s'){
            steps{
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sshagent(['k8s']) {
                    sh "scp -o StrictHostKeyChecking=no services.yml node-app-pod.yml ubuntu@3.101.105.176:/home/ubuntu/"
                    script {
                    try {
                        sh "ssh ubuntu@3.101.105.176 kubectl apply -f ."
                    }catch(error){
                        sh "ssh ubuntu@3.101.105.176 kubectl create -f ."
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
