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
                    sh "scp -o StrictHostKeyChecking=no services.yml ubuntu@54.219.37.205:/home/ubuntu/"
                    script {
                    try {
                        sh "echo sudo su"
                        sh "ssh ubuntu@54.219.37.205 kubectl apply -f ."
                    }catch(error){
                        sh "echo sudo su"
                        sh "ssh ubuntu@54.219.37.205 kubectl create -f ."
                    }
                }
                    

                }
            }
            }
        }
    }


