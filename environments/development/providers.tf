
provider "aws" {
  alias   = "acm"
  region  = "us-east-1"
  version = "~> 2.60.0"
}

provider "aws" {
  region  = "eu-central-1"
  version = "~> 2.60.0"
}