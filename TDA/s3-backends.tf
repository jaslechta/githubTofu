terraform {
  backend "s3" {
    bucket  = ""
    key     = "vault/TDA/opentofu.tfstate"
    region  = ""
    encrypt = true
  }
}
