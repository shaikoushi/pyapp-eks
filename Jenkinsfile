pipeline {
    agent any

    stages {
        stage("Docker Login & Build") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_pas', passwordVariable: 'pwd', usernameVariable: 'usr')]) {
                    sh """
                        echo "${pwd}" | docker login -u "${usr}" --password-stdin
                        docker pull python:3.12-slim   # ensure base image is pulled with auth
                        docker build -t chand0786/pyappeks:${env.BUILD_NUMBER} .
                    """
                }
            }
        }

        stage("Push To Docker Hub") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_pas', passwordVariable: 'pwd', usernameVariable: 'usr')]) {
                    sh """
                        echo "${pwd}" | docker login -u "${usr}" --password-stdin
                        docker push chand0786/pyappeks:${env.BUILD_NUMBER}
                    """
                }
            }
        }

        stage("Update Tag in Deployment YAML and Push") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'shaikoushi_git', passwordVariable: 'gitPwd', usernameVariable: 'gitUser')]) {
                    sh """
                        git config user.name "Jenkins Server"
                        git config user.email "jenkins@automation.com"
                        yq e '.spec.template.spec.containers[0].image = "chand0786/pyappeks:${env.BUILD_NUMBER}"' -i ./k8s/pyapp-deployment.yml
                        git add ./k8s/pyapp-deployment.yml
                        git commit -m 'Docker tag updated by Jenkins: ${env.BUILD_NUMBER}' || echo "No changes to commit"
                        git push https://${gitUser}:${gitPwd}@github.com/shaikoushi/pyapp-eks.git HEAD:main
                    """
                }
            }
        }
    }
}
