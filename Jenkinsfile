pipeline {
    agent any
    stages {
        stage("Docker Login & Build") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_pas', passwordVariable: 'PWD', usernameVariable: 'USR')]) {
                    sh """
                        echo $PWD | docker login -u $USR --password-stdin
                        docker build -t chand0786/pyappeks:${env.BUILD_NUMBER} .
                    """
                }
            }
        }
        stage("Push To Docker Hub") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_pas', passwordVariable: 'PWD', usernameVariable: 'USR')]) {
                    sh """
                        echo $PWD | docker login -u $USR --password-stdin
                        docker push chand0786/pyappeks:${env.BUILD_NUMBER}
                    """
                }
            }
        }
        stage("Update Tag in Deployment YAML and Push") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'shaikoushi_git', passwordVariable: 'GIT_PWD', usernameVariable: 'GIT_USER')]) {
                    sh """
                        git config user.name "Jenkins Server"
                        git config user.email "jenkins@automation.com"
                        yq e '.spec.template.spec.containers[0].image = "chand0786/pyappeks:${env.BUILD_NUMBER}"' -i ./k8s/pyapp-deployment.yml
                        git add .
                        git commit -m 'Docker tag updated by jenkins'
                        git push https://${GIT_USER}:${GIT_PWD}@github.com/shaikoushi/pyapp-eks.git main
                    """
                }
            }
        }
    }
}
