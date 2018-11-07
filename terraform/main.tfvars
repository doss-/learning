region = "us-east-1"

shared_credentials_file = "/home/dos/.aws/credentials"
profile = "terraform"

my_ami = {
  us-east-1 = "ami-0ff8a91507f77f867"
  eu-central-1 = "ami-0233214e13e500f77"
}

key_name = "aws_me.pem"

s3_bucket = "dos-deepdive"
