terraform {
  backend "s3" {
    bucket  = ""
    key     = "vault/PRO/opentofu.tfstate"
    region  = ""
    encrypt = true
  }
}
