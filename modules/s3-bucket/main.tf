# -----------------------------------------------------------------------------
# File: modules/s3-bucket/main.tf
# Purpose:
#   Implements resource orchestration for module 's3-bucket'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in
# variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

# Resource Purpose: Creates a Simple Storage Service (S3) bucket for object
# storage (aws_s3_bucket.this).
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = var.tags
}

# Resource Purpose: Enables or configures object versioning on a Simple Storage
# Service (S3) bucket (aws_s3_bucket_versioning.this).
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    # Ternary Purpose: Selects the "status" value by evaluating a condition and
    # choosing true/false branches explicitly.
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Resource Purpose: Configures default server-side encryption for a Simple
# Storage Service (S3) bucket
# (aws_s3_bucket_server_side_encryption_configuration.this).
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
      # Ternary Purpose: Selects the "kms_master_key_id" value by evaluating a
      # condition and choosing true/false branches explicitly.
      kms_master_key_id = var.sse_algorithm == "aws:kms" ? var.kms_key_id : null
    }
  }
}

# Resource Purpose: Configures Simple Storage Service (S3) object ownership
# enforcement behavior (aws_s3_bucket_ownership_controls.this).
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.object_ownership
  }
}

# Resource Purpose: Defines lifecycle rules to expire or transition Simple
# Storage Service (S3) objects (aws_s3_bucket_lifecycle_configuration.this).
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and
  # choosing true/false branches explicitly.
  count  = var.enable_lifecycle_rule ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "expire-objects"
    status = "Enabled"

    expiration {
      days = var.lifecycle_expiration_days
    }

    filter {
      prefix = ""
    }
  }
}

# Resource Purpose: Applies Simple Storage Service (S3) public access block
# controls to prevent unintended exposure
# (aws_s3_bucket_public_access_block.this).
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Data Purpose: Reads data source
# aws_iam_policy_document.deny_insecure_transport to fetch existing Amazon Web
# Services (AWS) context required by dependent expressions.
data "aws_iam_policy_document" "deny_insecure_transport" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and
  # choosing true/false branches explicitly.
  count = var.enforce_ssl_requests ? 1 : 0

  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

# Resource Purpose: Applies a bucket policy to enforce access and security
# constraints (aws_s3_bucket_policy.deny_insecure_transport).
resource "aws_s3_bucket_policy" "deny_insecure_transport" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and
  # choosing true/false branches explicitly.
  count = var.enforce_ssl_requests ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.deny_insecure_transport[0].json
}
