pipeline{
    agent any
    stages{
        stage("Docker Image"){
            steps{
                sh "docker build -t chand0786/pyappeks:${env.BUILD_NUMBER} ."
            }
        }
        stage("Pust To Docker Hub"){
            steps{
              withCredentials([usernamePassword(credentialsId: 'docker-credentials', passwordVariable: 'pwd', usernameVariable: 'doker_04')]) {
                    sh "docker login -u ${usr} -p ${pwd}"
                    sh "docker push chand0786/pyappeks:${env.BUILD_NUMBER}"
                }
            }
        }
        stage("Update Tag in Deployment YAML and push"){
            steps{
              withCredentials([usernamePassword(credentialsId: 'shaikoushi', passwordVariable: 'pwd', usernameVariable: 'git_new')]){
                    sh """
                     git config user.name "Jenkins Server"
                     git config user.email "jenkins@automation.com"
                     yq e '.spec.template.spec.containers[0].image = "chand0786/pyappeks:${env.BUILD_NUMBER}"' -i ./k8s/pyapp-deployment.yml
                     git add .
                     git commit -m 'Docker tag updated by jenkins'
                     git push origin main
                 """
                }
            }
        }
    }
}
