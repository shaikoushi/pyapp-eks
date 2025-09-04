pipeline{
    agent any
    stages{
        stage("Docker Image"){
            steps{
                sh "docker build -t kammana/pyappeks:${env.BUILD_NUMBER} ."
            }
        }
        stage("Pust To Docker Hub"){
            steps{
                withCredentials([usernameColonPassword(credentialsId: 'docker-aug', variable: '')])  {
                    sh "docker login -u ${usr} -p ${pwd}"
                    sh "docker push kammana/pyappeks:${env.BUILD_NUMBER}"
                }
            }
        }
        stage("Update Tag in Deployment YAML and push"){
            steps{
                withCredentials([usernameColonPassword(credentialsId: 'GIT', variable: '')]) {
                    sh """
                     git config user.name "Jenkins Server"
                     git config user.email "jenkins@automation.com"
                     yq e '.spec.template.spec.containers[0].image = "kammana/pyappeks:${env.BUILD_NUMBER}"' -i ./k8s/pyapp-deployment.yml
                     git add .
                     git commit -m 'Docker tag updated by jenkins'
                     git push origin main
                 """
                }
            }
        }
    }
}
