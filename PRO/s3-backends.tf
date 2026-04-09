terraform {
  backend "s3" {
    bucket  = ""
    key     = "vault/PRO/terraform.tfstate"
    region  = ""
    encrypt = true
  }
}
