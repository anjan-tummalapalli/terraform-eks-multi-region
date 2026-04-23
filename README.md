# Multi-Region EKS + CI/CD Terraform

This Terraform project provisions modular AWS infrastructure for:

- Primary region: `ap-south-1`
- Disaster recovery region: `ap-southeast-1`
- Amazon EKS clusters in both regions
- Basic networking (VPC, public/private subnets, route tables, NAT, IGW)
- Basic IAM for EKS, worker nodes, and CI/CD
- CI/CD with CodeCommit, CodeBuild, CodePipeline, and ECR

## Architecture Modules

- `modules/vpc`: Region VPC and subnet topology
- `modules/iam-basic`: IAM roles for EKS control plane and nodes
- `modules/eks`: EKS cluster and managed node group
- `modules/cicd`: ECR + CodeCommit + CodeBuild + CodePipeline
- `modules/regional-stack`: Composition module for one region
- `modules/s3-bucket`: S3 bucket with encryption, versioning, lifecycle
- `modules/rds-postgres`: PostgreSQL RDS instance with subnet group and security group
- `modules/lambda-function`: Lambda function + execution role + log group
- `modules/sqs-queue`: Standard/FIFO SQS queue
- `modules/alb`: Application Load Balancer + target group + listener

Root module deploys two regional stacks with provider aliases:

- `module.primary` using provider `aws.primary`
- `module.dr` using provider `aws.dr`

## Prerequisites

- Terraform `>= 1.5.0`
- AWS credentials with permissions for VPC, IAM, EKS, ECR, CodeCommit, CodeBuild, CodePipeline, S3

## Quick Start

1. Copy and adjust input variables:

```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Initialize Terraform:

```bash
terraform init
```

3. Review plan:

```bash
terraform plan
```

4. Apply:

```bash
terraform apply
```

## Notes

- This template creates one EKS cluster per region for high availability and disaster recovery readiness.
- DR CI/CD can be toggled using `enable_dr_pipeline` (default is `false` for cost optimization).
- Cost-optimized defaults are included: `SPOT` nodes, single NAT gateway per region, smaller DR node group.
- NAT gateway per AZ provides better availability but increases cost.
- Pipeline source is CodeCommit. Push your app and Kubernetes manifests to the configured repositories.
- Build/deploy behavior is controlled by module buildspec (`modules/cicd/buildspec.yml.tftpl`).
- Additional service module usage example is available at `examples/common-services`.
