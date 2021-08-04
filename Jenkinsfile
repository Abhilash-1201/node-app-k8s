pipeline {
    agent any
    environment {
        dockerImage = ''
        registry = 'abhilashnarayan/nodeapp'
        registryCredential = 'dockerhub-id'
    }
    stages{
        stage("checkout") {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Abhilash-1201/node-app-k8s.git']]])
            }
        }
        stage("Build Image") {
            steps {
                script {
                    dockerImage = docker.build registry
                }
            }
        }

        stage ('Uploading Image') {
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                    dockerImage.push()
                    }
                }
            }
        }
        stage('Docker Deploy k8s'){
            steps{
                sshagent(['k8s']) {
                    sshagent (credentials: ['k8s'])
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


