
pipeline {
    agent any

    environment {
        APP_DIR     = "/opt/devops-app"
        AWS_REGION  = "us-east-1"
        ECR_URI     = "381492189413.dkr.ecr.us-east-1.amazonaws.com/devops-repo"
        ECS_CLUSTER = "devops-cluster"
        ECS_SERVICE = "app-service"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                sh '''
                cd $APP_DIR

                echo "Building Docker image..."
                docker build -t devops-app .
                
                echo "Tagging image..."
                docker tag devops-app:latest $ECR_URI:latest
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                echo "Logging into ECR..."
                aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS --password-stdin $ECR_URI

                echo "Pushing image..."
                docker push $ECR_URI:latest
                '''
            }
        }

        stage('Deploy to ECS Fargate') {
            steps {
                sh '''
                echo "Triggering ECS deployment..."
                aws ecs update-service \
                  --cluster $ECS_CLUSTER \
                  --service $ECS_SERVICE \
                  --force-new-deployment
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment successful ✅'
        }
        failure {
            echo 'Deployment failed ❌'
        }
    }
}
