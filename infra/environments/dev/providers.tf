provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "tripire-devops-assessment"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "Krishna Kala"
    }
  }
}