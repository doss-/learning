# create the VPC
resource "aws_vpc" "Sandbox_VPC1" {
  cidr_block           = var.vpcMainCIDRblock
  instance_tenancy     = var.instanceTenancy # ALWAYS MUST be 'default'
  # Use AWS Route53 Resolver 
  enable_dns_support   = var.dnsSupport 
  # Create DNS Entries for new EC2 Instances with Public IP
  enable_dns_hostnames = var.dnsHostNames
  
  tags = {
    Name = "Sandbox VPC1"
    Category = "Sandbox"
  }
}


# Create the Subnet
resource "aws_subnet" "Main_Subnet" {
  vpc_id = aws_vpc.Sandbox_VPC1.id
  cidr_block = var.subnetCIDRblock
  availability_zone = var.availabilityZone
  # Assign Public IP from AWS Pool (not controlled by me)
  map_public_ip_on_launch = var.mapPublicIP

  tags = {
    Name = "Sandbox_Main_Subnet"
    Category = "Sandbox"
  }
}