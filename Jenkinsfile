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
        try {
        sh '''
            docker-compose -f docker-compose.yml  up
            wget https://github.com/arminc/clair-scanner/releases/download/v8/clair-scanner_linux_amd64
            mv clair-scanner_linux_amd64 clair-scanner
            chmod +x clair-scanner
            retries=0
            echo "Waiting for clair daemon to start"
            while( ! wget -T 10 -q -O /dev/null http://localhost:6060/v1/namespaces ) ; do sleep 1 ;echo -n "." ; if [ $retries -eq 10 ] ; then echo " Timeout, aborting." ; exit 1 ; fi ; retries=$(($retries+1)) ; done
            ./clair-scanner --ip $(docker network inspect bridge --format '{{range .IPAM.Config}}{{.Gateway}}{{end}}') -t High lt.zerum8/simple-docker-app:latest || true
        '''
        } finally {
             sh 'docker-compose -f docker-compose.yml down'
        }
    }
}
