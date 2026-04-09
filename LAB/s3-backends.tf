terraform {
  backend "s3" {
    bucket  = ""
    key     = "vault/LAB/terraform.tfstate"
    region  = ""
    encrypt = true
  }
}
