terraform {
  backend "s3" {
    bucket = "dos-deepdiveresized"
    region = "us-east-1"
    key = "cdp/tfstate/terraform.tfstate"
  }
}
