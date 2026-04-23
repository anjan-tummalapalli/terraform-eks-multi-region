provider "aws" {
  alias   = "primary"
  region  = var.primary_region
  profile = var.aws_profile != "" ? var.aws_profile : null
}

provider "aws" {
  alias   = "dr"
  region  = var.dr_region
  profile = var.aws_profile != "" ? var.aws_profile : null
}
