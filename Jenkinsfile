node {
        
        def docker
        def dockerCMD
        def ipAddress
        def aptUpdate
        def dockerInstall
        def dockerStart
        def dockerRun
        def user
       
        
           stage('Preparation') { 
                echo 'preparing the environment'
                docker = tool name: 'docker', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
                dockerCMD = "$docker/bin/docker"
                ipAddress = "18.188.128.194"
                aptUpdate = "sudo apt update"
                dockerInstall = "sudo apt install -y docker.io"
                dockerStart = "sudo service docker start"
                dockerRun = "sudo docker run -itd -p 80:8080 --name=addressbook shubhamkushwah123/addressbook:1.0"
                user = "ubuntu"
           }
           
           stage('git checkout'){
               echo 'checking out code from github repository'
               git 'https://github.com/shubhamkushwah123/docker-demo.git'
           }
           stage('compile Test and Package') {
             echo 'Compile code, Testing and Packaging'
             sh 'mvn clean package'
           }
           
           stage('Integration Test'){
               echo 'Running Integration Test Using Selenium'
               // run integration test
           }
            
           stage('Results') {
              echo 'generating Junit Reports'
              junit '**/target/surefire-reports/*.xml'
           }
           
           
            stage('Build docker image') {
                echo 'building docker image from Dockerfile'
                sh "${dockerCMD} build -t shubhamkushwah123/addressbook:1.0 ."
            }
            
            stage('Push docker image') {
                echo 'Authenticating user to push image on Docker hub'
                withCredentials([string(credentialsId: 'dockerPwd', variable: 'dockerHubPwd')]) {
            //    sh "${dockerCMD} login -u shubhamkushwah123 -p ${dockerHubPwd}"
                }
                echo 'pushing image on docker hub'
             //  sh "${dockerCMD} push shubhamkushwah123/addressbook:1.0"
             }
              
            stage('Run Apt Update'){
              echo 'establishing ssh connection to run apt update'
              sshagent(['aws-ubuntu']) {
                   sh "ssh -o StrictHostKeyChecking=no ${user}@${ipAddress} ${aptUpdate}" 
                  }
            }  
            
            stage('Docker  Install'){
                echo 'Installing docker on aws Instance'
                 sshagent(['aws-ubuntu']) {
                   sh "ssh -o StrictHostKeyChecking=no ${user}@${ipAddress} ${dockerInstall}" 
               }
            }
            
            stage('Docker Start'){
                echo 'Starting docker on aws Instance'
                 sshagent(['aws-ubuntu']) {
                   sh "ssh -o StrictHostKeyChecking=no ${user}@${ipAddress} ${dockerStart}" 
              }
            }
            
            stage('Deploy Application'){
                echo 'Deploying Application on aws Instance'
              sshagent(['aws-ubuntu']) {

                   sh "ssh -o StrictHostKeyChecking=no ${user}@${ipAddress} ${dockerRun}" 
               }
            }  
    } // node end

