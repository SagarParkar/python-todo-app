Python REST API Dockerized with Docker, AKS Deployment with Terraform, and Helm Chart
This is a sample Python-based REST API that has been dockerized using Docker, can be deployed on an AKS cluster using Terraform code, and has a basic Helm chart for deployment.

Prerequisites
To use this application, you will need the following:

1.Docker
2.Kubernetes cluster (AKS, GKE, EKS, etc.)
3.Terraform
4.Helm
5.Python 3.6 or later

Usage

Python APP
1. Python app build using REST APIs
2. Index.html file for frontend of the app


Dockerize the application
To dockerize the application, follow these steps:

##Clone this repository: git clone https://github.com/<your-username>/<your-repo-name>.git
##Navigate to the project directory: cd <your-repo-name>
1.Build the Docker image: docker build -t <your-docker-registry>/<your-image-name>:<your-tag> .
2.Push the Docker image to your registry: docker push <your-docker-registry>/<your-image-name>:<your-tag>

Deploy AKS using Terraform
To deploy the application on an AKS cluster using Terraform, follow these steps:

#Clone this repository: git clone https://github.com/<your-username>/<your-repo-name>.git
1.Navigate to the project directory: cd <your-repo-name>/terraform_files
2.Modify the terraform.tfvars file to match your AKS cluster configuration
3.Run terraform init to initialize the Terraform modules
4.Run terraform plan to view the resources that will be created
5.Run terraform apply to create the resources on your AKS cluster


Deploy APP on AKS using Helm chart
To deploy the application using a Helm chart, follow these steps:

#Clone this repository: git clone https://github.com/<your-username>/<your-repo-name>.git
1.Navigate to the project directory: cd <your-repo-name>/to-do-app-helm
2.Modify the values.yaml file to match your application and deployment configuration
3.Run helm install <release-name> . to deploy the application using the Helm chart

It also contains Kubernetes manifest files to deploy manually.
It also container a jenkinsFile FOR CI-CD deployment using ARGO-CD.

