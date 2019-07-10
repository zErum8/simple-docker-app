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

        withDockerNetwork{ n ->
           docker.image('arminc/clair-db:latest').withRun("--network ${n} --name postgres") {
                docker.image('arminc/clair-local-scan:v2.0.8_fe9b059d930314b54c78f75afe265955faf4fdc1').withRun("--network ${n} -p 6060:6060 --name clair --restart on-failure") {
                sh '''
                    wget https://github.com/arminc/clair-scanner/releases/download/v8/clair-scanner_linux_amd64
                    mv clair-scanner_linux_amd64 clair-scanner
                    chmod +x clair-scanner
                    ./clair-scanner --ip $(docker network inspect bridge --format '{{range .IPAM.Config}}{{.Gateway}}{{end}}') -t High lt.zerum8/simple-docker-app:latest || true
                '''
              }
           }
        }
    }
}

def withDockerNetwork(Closure inner) {
    try {
        networkId = UUID.randomUUID().toString()
        sh "docker network create ${networkId}"
        inner.call(networkId)
    } finally {
        sh "docker network rm ${networkId}"
    }
}
