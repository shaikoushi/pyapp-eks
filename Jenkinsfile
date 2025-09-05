pipeline{
    agent any
    stages{
        stage("Docker Image"){
            steps{
          withCredentials([usernamePassword(credentialsId: 'chan_doc', passwordVariable: 'pwd', usernameVariable: 'usr')]){
                sh "docker build -t chand0786/pyappeks:${env.BUILD_NUMBER} ."
          }
            }
        }
        stage("Pust To Docker Hub"){
            steps{
              withCredentials([usernamePassword(credentialsId: 'chan_doc', passwordVariable: 'pwd', usernameVariable: 'usr')]) {
                    sh "docker login -u ${usr} -p ${pwd}"
                    sh "docker push chand0786/pyappeks:${env.BUILD_NUMBER}"
                }
            }
        }
        stage("Update Tag in Deployment YAML and push"){
            steps{
            withCredentials([usernamePassword(credentialsId: 'shaikoushi_git', gitToolName: 'Default')]){
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
