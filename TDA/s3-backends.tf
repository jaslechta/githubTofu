terraform {
  backend "s3" {
    bucket  = "REPLACE_ME_TFSTATE_BUCKET"
    key     = "vault/TDA/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}