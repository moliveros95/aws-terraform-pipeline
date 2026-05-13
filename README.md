# AWS Infrastructure with OpenTofu + GitHub Actions CI/CD

## Overview
This project provisions AWS infrastructure using OpenTofu (IaC) and automates 
deployment through a GitHub Actions CI/CD pipeline. It covers two components:
1. Core AWS infrastructure (VPC, EC2, S3)
2. Containerized Flask app deployed to ECS Fargate via ECR

Every push to `main` automatically provisions infrastructure and deploys the 
latest Docker image. Destroy can be triggered manually via workflow dispatch.

## Architecture

### Core Infrastructure
- **VPC** – Isolated network with a public subnet
- **EC2** – t2.micro instance (Amazon Linux 2)
- **S3** – Private bucket with public access blocked
- **Internet Gateway + Route Table** – Public internet access for the subnet
- **Security Group** – SSH access on port 22
- **S3 Remote Backend** – OpenTofu state stored in S3 for pipeline and local sync

### Containerized App
- **Flask API** – Lightweight Python app with `/` and `/health` endpoints
- **Docker** – App packaged into a container image
- **AWS ECR** – Private registry storing the Docker image
- **AWS ECS Fargate** – Runs the container serverlessly
- **IAM** – Task execution role and user policies managed as code

## CI/CD Pipeline Flow
Push to main
→ OpenTofu provisions infrastructure (VPC, EC2, S3, ECR, ECS)
→ Docker builds and tags image with commit SHA
→ Image pushed to ECR (latest + commit SHA tag)
→ ECS pulls latest image and runs the container

## Tools & Technologies
- [OpenTofu](https://opentofu.org/) – Infrastructure as Code
- [AWS](https://aws.amazon.com/) – Cloud provider (ap-southeast-1)
- [Docker](https://www.docker.com/) – Containerization
- [GitHub Actions](https://github.com/features/actions) – CI/CD pipeline

## Project Structure
```
aws-terraform-pipeline/
├── .github/
│   └── workflows/
│       └── terraform.yml
├── app/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── ecr.tf
├── ecs.tf
├── iam.tf
└── .gitignore
```

## Prerequisites
- AWS account with CLI configured
- OpenTofu installed
- Docker installed
- S3 bucket for remote state (`mavs-tofu-state-2026`)
- GitHub repository secrets set:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

## Usage

### Deploy manually
```bash
tofu init
tofu plan
tofu apply
```

### Build and push Docker image manually
```bash
aws ecr get-login-password --region ap-southeast-1 | \
docker login --username AWS --password-stdin \
<account-id>.dkr.ecr.ap-southeast-1.amazonaws.com

docker build -t flask-app ./app
docker push <account-id>.dkr.ecr.ap-southeast-1.amazonaws.com/flask-app:latest
```

### Destroy infrastructure
```bash
tofu destroy
```

### CI/CD
- **Apply** – Push to `main`, pipeline runs automatically
- **Destroy** – Actions → OpenTofu CI/CD → Run workflow → select `destroy`

## Remote State
State is stored remotely in S3 (`mavs-tofu-state-2026`), ensuring consistent 
state between local and pipeline executions.

## App Endpoints
| Endpoint | Method | Response |
|----------|--------|----------|
| `/` | GET | `{"status": "ok", "message": "Hello from ECS!"}` |
| `/health` | GET | `{"status": "healthy"}` |