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
        def image = docker.build("lt.zerum8/simple-docker-app")
        sh '''
            docker run -p 5432:5432 -d --name db arminc/clair-db:latest
            sleep 15
            docker run -p 6060:6060 --link db:postgres -d --name clair --restart on-failure arminc/clair-local-scan:v2.0.8_fe9b059d930314b54c78f75afe265955faf4fdc1
            sleep 5
            wget https://github.com/arminc/clair-scanner/releases/download/v8/clair-scanner_linux_amd64
            mv clair-scanner_linux_amd64 clair-scanner
            chmod +x clair-scanner
            ./clair-scanner --ip $(docker network inspect bridge --format '{{range .IPAM.Config}}{{.Gateway}}{{end}}') -t High lt.zerum8/simple-docker-app:latest
        '''
    }
}
