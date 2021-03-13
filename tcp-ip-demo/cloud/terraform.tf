provider "aws" {
  region                  = var.region
  # this one is outdated somewhere from 0.12 or so
  #profile                 = "${var.profile}"
  profile                 = var.profile
}