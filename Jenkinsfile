try{
    node{
        
        def mavenHome
        def mavenCMD
        def docker
        def dockerCMD
        def tagName = "1.0"
        
        stage('preparation'){
             echo "preparing the environment..."
             mavenHome = tool name: 'maven 3', type: 'maven'
             mavenCMD = "${mavenHome}/bin/mvn" 
             docker=tool name: 'docker', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
             dockerCMD = "$docker/bin/docker"
        }
        stage('git checkout'){
            echo "checking out code from git repository ..."
            git 'https://www.github.com/shubhamkushwah123/bootcamp10.git'
        }
        
        stage('Build, Test and Package'){
            echo "Budiling the addressbook application..."
            sh "${mavenCMD} clean package"
        }
        
        stage('Sonar Scan'){
            echo "Scanning application for potential vulnerabilities ..."
            //sh 'mvn sonar:sonar -Dsonar.host.url=http://34.70.58.106:9000'
        }
        
        stage('publish report'){
            echo "Publishing HTML reports..."
            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: ''])
        }
        
        stage('Building Docker Image'){
            echo "Building docker images for addressbook application"
            sh "${dockerCMD} build -t shubhamkushwah123/addressbook:${tagName} ."
        }
        
        stage('docker push'){
            withCredentials([string(credentialsId: 'dockerPwd', variable: 'dockerHubPwd')]) {
                sh "${dockerCMD} login -u shubhamkushwah123 -p ${dockerHubPwd}"
                sh "${dockerCMD} push shubhamkushwah123/addressbook:${tagName}"
                
            }
        }
        stage('Deploy Application'){
            echo "Executing Ansible playbook..."
            echo "Installing required softwares in the nodes"
            echo "Deploying application..."
            //ansiblePlaybook colorized: true, credentialsId: 'ssh', disableHostKeyChecking: true, installation: 'ansible 2.9.22', inventory: '/etc/ansible/hosts', playbook: 'deploy-playbook.yml'
            
        }
        
        stage('clean up'){
            echo "clearning up the workspace..."
            cleanWs()
        }
        
        stage('Send Email'){
            echo "Sending email to the user"
            emailext attachLog: true, body: '''Dear Developer, 
            Please be informed that your build has been currentBuild.result. Request you to please have a look''', subject: 'Build Status', to: 'shubhamkushwah123'
        }
        currentBuild.result = 'SUCCESS'
    }
}
finally {
    (currentBuild.result != "ABORTED") && node("master") {
     // Send e-mail notifications for failed or unstable builds.
     // currentBuild.result must be non-null for this step to work.
     step([$class: 'Mailer',
     notifyEveryUnstableBuild: true,
     recipients: 'some email id',
     sendToIndividuals: true])
    }
}
