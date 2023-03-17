podTemplate(yaml: '''
    apiVersion: v1
    kind: Pod
    spec:
      containers:
      - name: gradle
        image: gradle:8-jdk8
        command:
        - sleep
        args:
        - 99d
        volumeMounts:
        - name: shared-storage
          mountPath: /mnt        
      - name: centos
        image: centos
        command:
        - sleep
        args:
        - 99d
      restartPolicy: Never
      volumes:
      - name: shared-storage
        persistentVolumeClaim:
          claimName: jenkins-pv-claim
      - name: kaniko-secret
        secret:
            secretName: dockercred
            items:
            - key: .dockerconfigjson
              path: config.json
''') {
  node(POD_LABEL) {

  stage('k8s') {
    git branch: 'main', url: 'https://github.com/bsieraduml/week8.git'
    container('centos') {
      stage('start calculator') {
        sh '''
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        chmod +x ./kubectl
        ./kubectl apply -f calculator.yaml
        ./kubectl apply -f hazelcast.yaml
          '''
        }
      }
    }

stage('Build a gradle project') {
      git branch: 'main', url: 'https://github.com/bsieraduml/week8.git'
      container('gradle') {
        stage('Test via curl') {
          sh '''
          pwd
          test $(curl calculator-service:8080/sum?a=6\\&b=2) -eq 3 && echo 'pass' || 'fail'
          '''
        } // stage build a gradle project

        stage("Acceptance Testing") {
            //exercise 8 part 1 test via curl

              try {
                sh '''
                echo 'try curl'
                sh "chmod +x acceptance_test_8_1.sh && ./acceptance_test_8_1.sh"
                // test $(curl calculator-service:8080/sum?a=6\\&b=2) -eq 3 && echo 'pass' || 'fail'
                // ./gradlew jacocoTestCoverageVerification
                // ./gradlew jacocoTestReport
                  '''
              } catch (Exception E) {
                  echo 'Failure detected'
              }

              // from the HTML publisher plugin
              // https://www.jenkins.io/doc/pipeline/steps/htmlpublisher/
              // publishHTML (target: [
              //     reportDir: 'build/reports/tests/test',
              //     reportFiles: 'index.html',
              //     reportName: "JaCoCo Report"
              // ])       

        } // stage code coverage  
      }
    }        

  } // NODE pod label
} //root