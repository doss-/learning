variable "region" {}

variable "shared_credentials_file" {}

variable "profile" {}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.shared_credentials_file}"
  profile                 = "${var.profile}"
}

variable "my_ami" {
  type = "map"
}
variable "key_name" {}

resource "aws_instance" "web" {
  ami = "${lookup(var.my_ami, var.region)}"
  instance_type = "t2.micro"

  #seems like something is wrong here
  #key_name = "${var.key_name}"

  tags {
    Name = "terraformed"
  }
}
