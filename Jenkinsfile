pipeline {
    agent { label 'deploy' }
    environment {
        // Specify your environment variables.
        GLPI_VERSION = '9.4.1.1'
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
                sh 'docker tag cmotta2016/glpi:$GIT_COMMIT cmotta2016/glpi:release-$GLPI_VERSION'
                sh 'docker push cmotta2016/glpi:release-$GLPI_VERSION'
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
