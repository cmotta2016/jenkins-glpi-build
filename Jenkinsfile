pipeline {
    agent { label 'deploy' }
    environment {
        // Specify your environment variables.
        APP_VERSION = '1.1'
    }
    stages {
        stage('Build') {
            steps {
                // Print all the environment variables.
                sh 'printenv'
                sh 'echo $GIT_BRANCH'
                sh 'echo $GIT_COMMIT'
                echo 'Building the docker images with the current git commit'
                sh 'docker build -t cmotta2016/glpi:$GIT_COMMIT .'
            }
        }
        stage('Test') {
            steps {
                echo 'PHP Unit tests'
                sh 'echo "Test Ok"'
                sh 'sleep 5'
            }
        }
        stage('Push') {
            steps {
                withDockerRegistry([ credentialsId: "docker-hub-credentials", url: "" ]) {
                echo 'Pushing docker images'
                sh 'docker tag cmotta2016/glpi:$GIT_COMMIT cmotta2016/glpi:release-9.3.2'
                sh 'docker push cmotta2016/glpi:release-9.3.2'
                }
            }
        }
        stage('Deploy') {
            steps {
                withDockerRegistry([ credentialsId: "docker-hub-credentials", url: "" ]) {
                echo 'Deploying stack'
                sh 'docker stack deploy -c docker-compose.yml glpi'
                }
            }
        }
    }
    post {
        always {
            // Always cleanup after the build.
            sh 'docker rmi -f cmotta2016/glpi:$GIT_COMMIT'
        }
    }
}
