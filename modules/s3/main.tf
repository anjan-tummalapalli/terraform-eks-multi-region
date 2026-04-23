module "bucket" {
  source = "../s3-bucket"

  bucket_name               = var.bucket_name
  versioning_enabled        = var.versioning_enabled
  force_destroy             = var.force_destroy
  enable_lifecycle_rule     = var.enable_lifecycle_rule
  lifecycle_expiration_days = var.lifecycle_expiration_days
  tags                      = var.tags
}
