terraform {
  backend "s3" {
    bucket  = ""
    key     = "vault/LAB/opentofu.tfstate"
    region  = ""
    encrypt = true
  }
}
