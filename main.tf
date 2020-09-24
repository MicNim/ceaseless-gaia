terraform {
  required_version = ">=0.13.0"
  backend "s3" {
    bucket         = "ceaseless-gaia-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "aws-locks"
    encrypt        = true
  }
}

provider "aws" {
  region  = "eu-central-1"
  version = "~> 2.60.0"
}

provider "aws" {
  alias   = "acm"
  region  = "us-east-1"
  version = "~> 2.60.0"
}

module "backend" {
  source               = "./modules/backend"
  name_of_s3_bucket    = "ceaseless-gaia-terraform-state"
  dynamo_db_table_name = "aws-locks"
}

module "dns" {
  source         = "./modules/dns"
  route53_domain = "phytology.co.uk"
}

module "website" {
  source                 = "./modules/website"
  bucket_name            = "dev.phytology.co.uk"
  route53_zone_id        = module.dns.route53_zone_id
  route53_hosted_zone_id = module.dns.route53_hosted_zone_id
  s3_force_destroy       = true
}

variable "aws_profile" {
  type        = string
  description = "AWS Profile to choose"
  default     = "default"
}

output "route53_app_fqdn" {
  value = module.website.route53_app_fqdn
}