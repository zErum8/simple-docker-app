#!groovy​

node {

    stage ('Clone') {
        checkout scm
    }

    stage('Build') {
        echo "Branch: ${env.BRANCH_NAME}"
        sh "./gradlew clean build"
    }

    stage('Docker') {
        docker.build("lt.zerum8/simple-docker-app")
        def clairEndpoint = "172.17.0.1"
        sh '''
            wget https://github.com/arminc/clair-scanner/releases/download/v8/clair-scanner_linux_amd64
            mv clair-scanner_linux_amd64 clair-scanner
            chmod +x clair-scanner
            ./clair-scanner --ip $(clairEndpoint) -t High lt.zerum8/simple-docker-app:latest || true
        '''
    }
}
