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
        
    }

}
def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}