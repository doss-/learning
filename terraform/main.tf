variable "region" {
  default = "us-east-1"
}

variable "shared_credentials_file" {
  default = "/home/dos/.aws/credentials"
}

variable "profile" {
  default = "terraform"
}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.shared_credentials_file}"
  profile                 = "${var.profile}"
}

variable "my_ami" {
  type = "map"
  default = {
    us-east-1 = "ami-0ff8a91507f77f867"
    eu-central-1 = "ami-0233214e13e500f77"
  }
  description = "North Virginia and Frankfurt"
}

resource "aws_instance" "web" {
  ami = "${lookup(var.my_ami, var.region)}"
  instance_type = "t2.micro"
  tags {
    Name = "terraformed"
  }
}
