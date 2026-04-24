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
- `modules/kms`: Customer-managed AWS KMS key with secure policy defaults
- `modules/cloudwatch`: CloudWatch log groups and metric alarms
- `modules/elb`: Classic ELB (Elastic Load Balancer) module
- `modules/athena`: Athena workgroup + optional database with query result controls
- `modules/sagemaker`: SageMaker notebook instance with optional IAM role and lifecycle config
- `modules/bedrock`: Bedrock model invocation logging configuration with CloudWatch/S3 delivery
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
- For new AI/data modules, ensure permissions for Athena, SageMaker, Bedrock, CloudWatch Logs, and IAM role creation.
- Bedrock availability is region-specific; run Bedrock examples in regions where Amazon Bedrock is supported.

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

## Documentation Standards

- Project-wide documentation and commenting rules are defined in [docs/DOCUMENTATION_BEST_PRACTICES.md](/Users/anjan/Documents/New%20project/terraform-eks-multi-region/docs/DOCUMENTATION_BEST_PRACTICES.md).
- All Terraform files include verbose context headers so maintainers can quickly understand purpose, interface boundaries, and safe change expectations.
- When module inputs/outputs, security defaults, or cost defaults change, update README and relevant examples in the same change.

## Notes

- This template creates one EKS cluster per region for high availability and disaster recovery readiness.
- DR CI/CD can be toggled using `enable_dr_pipeline` (default is `false` for cost optimization).
- Cost-optimized defaults are included: `SPOT` nodes, `t3.small` worker type baseline, single NAT gateway per region, and smaller DR node group.
- NAT gateway per AZ provides better availability but increases cost.
- Pipeline source is CodeCommit. Push your app and Kubernetes manifests to the configured repositories.
- Build/deploy behavior is controlled by module buildspec (`modules/cicd/buildspec.yml.tftpl`).
- Module-level cost defaults are also optimized: Lambda `128 MB` memory + `7-day` logs, CloudWatch log groups default to `7-day` retention, RDS backup retention defaults to `3 days`, EC2 root volume defaults to `8 GiB gp3`, and Classic ELB cross-zone load balancing defaults to `false`.
- Athena/SageMaker/Bedrock modules are cost-optimized by default: Athena includes a per-query scan cutoff (`1 GiB`), SageMaker defaults to `ml.t3.medium` with small volume sizing, and Bedrock logging defaults to text payload logging with short retention and optional lifecycle-managed S3 storage.
- For stronger resilience/compliance, increase these values (for example longer backup/log retention, larger instance sizes, and cross-zone load balancing).
- Additional service module usage example is available at `examples/common-services`.
- Focused EC2 + S3 + VPC example is available at `examples/ec2-s3-vpc`.
- DB-focused example (`MySQL + DynamoDB + Redis + SNS`) is available at `examples/db-services`.
- Lambda-focused example is available at `examples/lambda-basic`.
- KMS-focused example is available at `examples/kms-basic`.
- CloudWatch-focused example is available at `examples/cloudwatch-basic`.
- Classic ELB-focused example is available at `examples/elb-basic`.
- Athena-focused example is available at `examples/athena-basic`.
- SageMaker-focused example is available at `examples/sagemaker-basic`.
- Bedrock-focused example is available at `examples/bedrock-basic`.

## Cost Optimization Methods

- Keep DR region lean: deploy minimum baseline capacity in `ap-southeast-1` and scale only during failover or DR drills.
- Run non-production environments on schedules: use automation to stop/start cost-heavy workloads outside business hours.
- Use right-sized compute first, then scale based on CloudWatch metrics instead of provisioning for peak from day one.
- Prefer managed encryption defaults (SSE-S3 where acceptable) before moving to KMS-heavy designs if compliance does not require customer-managed keys.
- Enforce retention and lifecycle policies for logs/artifacts to avoid unbounded storage growth.

Service-specific methods in this repo:

- EKS and VPC:
  Reduce worker count and use `SPOT` where possible; keep single NAT gateway for cost unless AZ-level egress HA is required.
- CI/CD:
  Keep `enable_dr_pipeline = false` by default and enable only when needed; use smaller CodeBuild compute/image options for non-prod.
- Athena:
  Use `bytes_scanned_cutoff_per_query` (default `1 GiB`) and enforce workgroup settings to prevent expensive ad-hoc scans.
- SageMaker:
  Start with `ml.t3.medium` and `5 GiB` volume baseline; disable direct internet and root access unless required; destroy idle notebooks in dev/test.
- Bedrock:
  Log only required payload types (`text_data_delivery_enabled` default `true`, others `false`) and keep short CloudWatch retention to reduce log cost.
- RDS/Redis:
  Keep single-AZ/non-production shapes by default; increase multi-AZ and larger sizes only for production SLO/compliance needs.
- S3:
  Enable lifecycle expiration for transient data (query results, artifacts, logs) and avoid `force_destroy = true` in production controls.

Recommended operational checks:

- Review monthly service spend by tag (`Environment`, `Team`, `Service`) and right-size modules quarterly.
- Set AWS Budgets and Cost Anomaly Detection at account/workload level for proactive alerts.
- Run `terraform plan` before apply and remove unused example stacks with `terraform destroy` after validation/testing.

## Usage Instructions (Athena, SageMaker, Bedrock)

Run each example independently:

1. `cd examples/athena-basic`
2. `cp terraform.tfvars.example terraform.tfvars`
3. Update `athena_results_bucket_name` with a globally unique S3 bucket name.
4. `terraform init && terraform plan && terraform apply`

1. `cd examples/sagemaker-basic`
2. `cp terraform.tfvars.example terraform.tfvars`
3. Update `notebook_data_bucket_name` with a globally unique S3 bucket name and tighten `notebook_ingress_cidrs`.
4. `terraform init && terraform plan && terraform apply`

1. `cd examples/bedrock-basic`
2. `cp terraform.tfvars.example terraform.tfvars`
3. Update `bedrock_logs_bucket_name` with a globally unique S3 bucket name.
4. `terraform init && terraform plan && terraform apply`

Destroy after testing to avoid ongoing charges: `terraform destroy`

## Security Defaults

- EKS supports private/public endpoint controls (`cluster_endpoint_private_access`, `cluster_endpoint_public_access`, `cluster_endpoint_public_access_cidrs`).
- EKS secrets encryption is enabled by default with KMS (`cluster_secrets_encryption_enabled`), including automatic KMS key rotation for module-managed keys.
- KMS module provides customer-managed keys with rotation, constrained key policies, configurable admin/usage principals, and alias support.
- S3 bucket module enforces encryption at rest, blocks public access, and denies non-TLS bucket requests by default.
- CI/CD artifact bucket is encrypted and configured to deny non-TLS requests.
- RDS MySQL/PostgreSQL modules default to encrypted storage (`storage_encrypted = true`) and keep databases private by default (`publicly_accessible = false`).
- EC2 instances enforce IMDSv2 and encrypted root volumes; module default ingress is empty (no inbound ports opened unless explicitly configured).
- Athena module enforces workgroup settings by default, encrypts query results, and supports explicit scan cutoffs to reduce accidental spend.
- SageMaker module defaults to private networking (`direct_internet_access = Disabled`), IMDSv2 minimum, and `root_access = Disabled`.
- Bedrock module supports CloudWatch/S3 log delivery with scoped IAM permissions and optional KMS encryption for CloudWatch logs.
- For production hardening, restrict EKS public endpoint CIDRs, provide customer-managed KMS keys, and enable deletion protection on stateful databases.

## Security Best Practices

- Apply least-privilege IAM: keep module role permissions scoped to required services/resources and avoid broad `*` actions/resources in custom policies.
- Keep network access private by default: prefer private subnets for stateful services and AI/ML notebooks; allow ingress only from explicit trusted CIDRs or security groups.
- Encrypt data in transit and at rest everywhere: enforce TLS-only S3 access, enable storage encryption for databases/cache, and use KMS-managed keys for regulated workloads.
- Protect secrets: never commit credentials in `*.tfvars`; use AWS Secrets Manager or SSM Parameter Store for runtime secrets and rotate regularly.
- Restrict Kubernetes exposure: keep EKS public endpoint CIDRs narrow, enable private endpoint access where possible, and use IAM Roles for Service Accounts (IRSA).
- Enable monitoring and detection: publish CloudWatch metrics/alarms, centralize audit logs (CloudTrail + service logs), and configure AWS Config/Security Hub/GuardDuty in production accounts.
- Use account and bucket ownership controls: set `expected_bucket_owner` where supported (for example Athena result configuration) to reduce cross-account misconfiguration risk.
- Enforce change governance: run `terraform plan` in CI, require code review for IAM/network changes, and separate environments/accounts for dev, staging, and production.

## Upgrade-Friendly Defaults

- EKS exposes upgrade controls: `cluster_upgrade_support_type`, `node_force_update_version`, `node_max_unavailable_percentage`.
- EKS add-ons support controlled pinning (`coredns_addon_version`, `kube_proxy_addon_version`, `vpc_cni_addon_version`) and conflict handling policies.
- RDS modules (`rds-postgres`, `rds-mysql`) support `auto_minor_version_upgrade`, `allow_major_version_upgrade`, `maintenance_window`, and `backup_window`.
- Redis module supports `auto_minor_version_upgrade`, `maintenance_window`, and snapshot retention settings.
- CI/CD build image upgrades can be controlled through `codebuild_image` and `codebuild_compute_type`.
- SageMaker module exposes lifecycle script configuration, IAM policy attachments, and KMS settings for controlled evolution.
- Athena module exposes engine version pinning and workgroup enforcement controls.
