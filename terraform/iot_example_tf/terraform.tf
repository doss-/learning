# during init enter bucket where tfstate is stored, path to it is in 'key'
# backend loaded before interpolation module so no interpolation and
#+ variables in backend
terraform {
  backend "s3" {
    region = "us-east-1"
    key = "cdp/tfstate/terraform.tfstate"
  }
}

# after init
# export TF_VAR_shared_credentials_file=/path/to/.aws/credentials
provider "aws" {
  region="${var.region}"
  shared_credentials_file = "${var.shared_credentials_file}"
  profile = "${var.profile}"
}

