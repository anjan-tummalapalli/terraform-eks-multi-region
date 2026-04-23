output "primary_region_summary" {
  description = "High-level summary of resources created in primary region."
  value = {
    region              = var.primary_region
    vpc_id              = module.primary.vpc_id
    cluster_name        = module.primary.cluster_name
    cluster_version     = module.primary.cluster_version
    cluster_endpoint    = module.primary.cluster_endpoint
    ecr_repository_url  = module.primary.ecr_repository_url
    codepipeline_name   = module.primary.codepipeline_name
    codecommit_repo_arn = module.primary.codecommit_repo_arn
  }
}

output "dr_region_summary" {
  description = "High-level summary of resources created in DR region."
  value = {
    region              = var.dr_region
    vpc_id              = module.dr.vpc_id
    cluster_name        = module.dr.cluster_name
    cluster_version     = module.dr.cluster_version
    cluster_endpoint    = module.dr.cluster_endpoint
    ecr_repository_url  = module.dr.ecr_repository_url
    codepipeline_name   = module.dr.codepipeline_name
    codecommit_repo_arn = module.dr.codecommit_repo_arn
  }
}
