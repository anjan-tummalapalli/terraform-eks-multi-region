provider "aws" {
  region = var.region
}

module "kms" {
  source = "../../modules/kms"

  name                    = "${var.name_prefix}-data"
  description             = "KMS key for encrypting application data resources"
  enable_key_rotation     = true
  deletion_window_in_days = 30
  admin_principal_arns    = var.admin_principal_arns
  usage_principal_arns    = var.usage_principal_arns
  service_principals = [
    "s3.amazonaws.com"
  ]
  additional_aliases = [
    "${var.name_prefix}-s3"
  ]
  tags = var.tags
}

module "secure_bucket" {
  source = "../../modules/s3"

  bucket_name          = var.s3_bucket_name
  versioning_enabled   = true
  sse_algorithm        = "aws:kms"
  kms_key_id           = module.kms.key_arn
  enforce_ssl_requests = true
  object_ownership     = "BucketOwnerEnforced"
  tags                 = var.tags
}
