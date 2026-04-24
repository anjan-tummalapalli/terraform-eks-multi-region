# -----------------------------------------------------------------------------
# File: modules/cicd/main.tf
# Purpose:
#   Implements resource orchestration for module 'cicd'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

locals {
  # Local Purpose: Defines derived value "name_prefix" once for reuse and consistent logic across this file.
  name_prefix = "${var.project_name}-${var.environment}-${replace(var.region, "-", "")}"
}

# Data Purpose: Reads data source aws_caller_identity.current to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
data "aws_caller_identity" "current" {}

# Resource Purpose: Generates a random string used for unique resource naming (random_string.suffix).
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
  numeric = true
}

# Resource Purpose: Creates an Elastic Container Registry (ECR) repository to store and version container images (aws_ecr_repository.app).
resource "aws_ecr_repository" "app" {
  name                 = "${var.project_name}-${var.environment}-${replace(var.region, "-", "")}-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

# Resource Purpose: Creates a Simple Storage Service (S3) bucket for object storage (aws_s3_bucket.artifacts).
resource "aws_s3_bucket" "artifacts" {
  bucket = lower(substr("${local.name_prefix}-artifacts-${random_string.suffix.result}", 0, 63))

  tags = var.tags
}

# Resource Purpose: Enables or configures object versioning on a Simple Storage Service (S3) bucket (aws_s3_bucket_versioning.artifacts).
resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Resource Purpose: Applies Simple Storage Service (S3) public access block controls to prevent unintended exposure (aws_s3_bucket_public_access_block.artifacts).
resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Resource Purpose: Configures default server-side encryption for a Simple Storage Service (S3) bucket (aws_s3_bucket_server_side_encryption_configuration.artifacts).
resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Data Purpose: Reads data source aws_iam_policy_document.artifacts_tls_only to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
data "aws_iam_policy_document" "artifacts_tls_only" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

# Resource Purpose: Applies a bucket policy to enforce access and security constraints (aws_s3_bucket_policy.artifacts_tls_only).
resource "aws_s3_bucket_policy" "artifacts_tls_only" {
  bucket = aws_s3_bucket.artifacts.id
  policy = data.aws_iam_policy_document.artifacts_tls_only.json
}

# Resource Purpose: Creates a CodeCommit repository for source version control (aws_codecommit_repository.this).
resource "aws_codecommit_repository" "this" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and choosing true/false branches explicitly.
  count           = var.create_codecommit_repo ? 1 : 0
  repository_name = var.codecommit_repo_name

  tags = var.tags
}

locals {
  # Local Purpose: Defines derived value "source_repo_name" once for reuse and consistent logic across this file.
  # Ternary Purpose: Selects the "source_repo_name" value by evaluating a condition and choosing true/false branches explicitly.
  source_repo_name = var.create_codecommit_repo ? aws_codecommit_repository.this[0].repository_name : var.codecommit_repo_name
}

# Data Purpose: Reads data source aws_iam_policy_document.codebuild_assume to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
data "aws_iam_policy_document" "codebuild_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Resource Purpose: Creates an Identity and Access Management (IAM) role assumed by Amazon Web Services (AWS) services or workloads (aws_iam_role.codebuild).
resource "aws_iam_role" "codebuild" {
  name               = "${local.name_prefix}-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume.json

  tags = var.tags
}

# Resource Purpose: Attaches an inline Identity and Access Management (IAM) policy document directly to a role (aws_iam_role_policy.codebuild).
resource "aws_iam_role_policy" "codebuild" {
  name = "${local.name_prefix}-codebuild-policy"
  role = aws_iam_role.codebuild.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.artifacts.arn,
          "${aws_s3_bucket.artifacts.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codecommit:GitPull"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "sts:GetCallerIdentity"
        ]
        Resource = "*"
      }
    ]
  })
}

# Data Purpose: Reads data source aws_iam_policy_document.codepipeline_assume to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
data "aws_iam_policy_document" "codepipeline_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Resource Purpose: Creates an Identity and Access Management (IAM) role assumed by Amazon Web Services (AWS) services or workloads (aws_iam_role.codepipeline).
resource "aws_iam_role" "codepipeline" {
  name               = "${local.name_prefix}-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume.json

  tags = var.tags
}

# Resource Purpose: Attaches an inline Identity and Access Management (IAM) policy document directly to a role (aws_iam_role_policy.codepipeline).
resource "aws_iam_role_policy" "codepipeline" {
  name = "${local.name_prefix}-codepipeline-policy"
  role = aws_iam_role.codepipeline.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.artifacts.arn,
          "${aws_s3_bucket.artifacts.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:UploadArchive",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:CancelUploadArchive"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild"
        ]
        Resource = "*"
      }
    ]
  })
}

# Resource Purpose: Defines a CodeBuild project that runs build and deployment steps (aws_codebuild_project.this).
resource "aws_codebuild_project" "this" {
  name         = "${local.name_prefix}-build"
  description  = "Build and deploy container workload to EKS"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.codebuild_compute_type
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }

    environment_variable {
      name  = "ECR_REPOSITORY_URI"
      value = aws_ecr_repository.app.repository_url
    }

    environment_variable {
      name  = "EKS_CLUSTER_NAME"
      value = var.cluster_name
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = templatefile("${path.module}/buildspec.yml.tftpl", {
      region = var.region
    })
  }

  tags = var.tags
}

# Resource Purpose: Defines a CodePipeline workflow to orchestrate Continuous Integration and Continuous Delivery (CI/CD) stages (aws_codepipeline.this).
resource "aws_codepipeline" "this" {
  name     = "${local.name_prefix}-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = local.source_repo_name
        BranchName           = var.repository_branch
        PollForSourceChanges = true
      }
    }
  }

  stage {
    name = "BuildAndDeploy"

    action {
      name             = "BuildAndDeploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.this.name
      }
    }
  }

  tags = var.tags
}
