module "bucket" {
  source = "../s3-bucket"

  bucket_name               = var.bucket_name
  versioning_enabled        = var.versioning_enabled
  sse_algorithm             = var.sse_algorithm
  kms_key_id                = var.kms_key_id
  force_destroy             = var.force_destroy
  enable_lifecycle_rule     = var.enable_lifecycle_rule
  enforce_ssl_requests      = var.enforce_ssl_requests
  object_ownership          = var.object_ownership
  lifecycle_expiration_days = var.lifecycle_expiration_days
  tags                      = var.tags
}
