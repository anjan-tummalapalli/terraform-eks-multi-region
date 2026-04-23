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
- `modules/ec2`: EC2 instance + security group
- `modules/s3`: S3 bucket module alias
- `modules/lambda`: AWS Lambda module alias
- `modules/cloudwatch`: CloudWatch log groups and metric alarms
- `modules/elb`: Classic ELB (Elastic Load Balancer) module
- `modules/iam-basic`: IAM roles for EKS control plane and nodes
- `modules/eks`: EKS cluster and managed node group
- `modules/cicd`: ECR + CodeCommit + CodeBuild + CodePipeline
- `modules/regional-stack`: Composition module for one region
- `modules/s3-bucket`: S3 bucket with encryption, versioning, lifecycle
- `modules/rds-postgres`: PostgreSQL RDS instance with subnet group and security group
- `modules/rds-mysql`: MySQL RDS instance with subnet group and security group
- `modules/dynamodb-table`: DynamoDB table (on-demand or provisioned)
- `modules/elasticache-redis`: Redis ElastiCache cluster with subnet/security groups
- `modules/sns-topic`: SNS topic with optional subscriptions
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
- Focused EC2 + S3 + VPC example is available at `examples/ec2-s3-vpc`.
- DB-focused example (`MySQL + DynamoDB + Redis + SNS`) is available at `examples/db-services`.
- Lambda-focused example is available at `examples/lambda-basic`.
- CloudWatch-focused example is available at `examples/cloudwatch-basic`.
- Classic ELB-focused example is available at `examples/elb-basic`.

## Upgrade-Friendly Defaults

- EKS exposes upgrade controls: `cluster_upgrade_support_type`, `node_force_update_version`, `node_max_unavailable_percentage`.
- EKS add-ons support controlled pinning (`coredns_addon_version`, `kube_proxy_addon_version`, `vpc_cni_addon_version`) and conflict handling policies.
- RDS modules (`rds-postgres`, `rds-mysql`) support `auto_minor_version_upgrade`, `allow_major_version_upgrade`, `maintenance_window`, and `backup_window`.
- Redis module supports `auto_minor_version_upgrade`, `maintenance_window`, and snapshot retention settings.
- CI/CD build image upgrades can be controlled through `codebuild_image` and `codebuild_compute_type`.
