pipeline {
    agent any
    stages {
        stage("Docker Image") {
            steps {
                sh "docker build -t chand0786/pyappeks:${env.BUILD_NUMBER} ."
            }
        }

        stage("Push To Docker Hub") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_pas', passwordVariable: 'DOCKER_PWD', usernameVariable: 'DOCKER_USER')]) {
                    sh """
                        echo "${DOCKER_PWD}" | docker login -u "${DOCKER_USER}" --password-stdin
                        docker push chand0786/pyappeks:${env.BUILD_NUMBER}
                    """
                }
            }
        }

        stage("Update Tag in Deployment YAML and Push") {
            steps {
                withCredentials([gitUsernamePassword(credentialsId: 'github_pas', gitToolName: 'Default')]{
                    sh """
                        git config user.name "Jenkins Server"
                        git config user.email "jenkins@automation.com"
                        
                        # Ensure we are on main branch
                        git checkout main
    
                        # Update YAML with new image tag
                        yq e '.spec.template.spec.containers[0].image = "chand0786/pyappeks:${env.BUILD_NUMBER}"' -i ./k8s/pyapp-deployment.yml
                        
                        git add .
                        git commit -m 'Docker tag updated by Jenkins' || echo "No changes to commit"
                        
                        git push origin main
                    """
                    
                }
            }
        }
    }
}
