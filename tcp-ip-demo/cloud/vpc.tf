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
resource "aws_subnet" "Sandbox_Main_Subnet" {
  vpc_id = aws_vpc.Sandbox_VPC1.id
  cidr_block = var.subnetCIDRblock
  availability_zone = var.availabilityZone
  # Assign Public IP from AWS Pool (not controlled by me)
  map_public_ip_on_launch = var.mapPublicIP

  tags = {
    Name = "Sandbox Main Subnet"
    Category = "Sandbox"
  }
}

# Create the Security Group
# There is Default SG attached to each EC2 Instance
# Max 5 SG for an Instance
# Docs: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html
#   Security groups are stateful — if you send a request from your instance, the response traffic for that request is allowed 
#   to flow in regardless of inbound security group rules. 
#   Responses to allowed inbound traffic are allowed to flow out, regardless of outbound rules. 
resource "aws_security_group" "Sandbox_Main_Security_Group" {
  vpc_id = aws_vpc.Sandbox_VPC1.id
  name = "Main Security Group"
  description = "Default SG for Sandbox VPC"

  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egressCIDRblock
  }

  tags = {
    Name = "Sandbox Main SG"
    Category = "Sandbox"
  }
}

# Create the Network Access Control List (NACL)
#   There is always default
#   Only 1 NACL for Subnet
#   Not Default NACL are Deniyin everything(In\Out)
resource "aws_network_acl" "Sandbox_Main_NACL" {
  vpc_id = aws_vpc.Sandbox_VPC1.id
  subnet_ids = [ aws_subnet.Sandbox_Main_Subnet.id ]

  # allow ingress port 22
  ingress {
    action = "allow"
    cidr_block = var.destinationCIDRblock
    from_port = 22
    to_port = 22
    protocol = "tcp"
    rule_no = 100    
  }

  # allow ingress port 80
  ingress {
    action = "allow"
    cidr_block = var.destinationCIDRblock
    from_port = 80
    to_port = 80
    protocol = "tcp"
    rule_no = 200
  }

  # allow Egress port 22
  egress {
    action = "allow"
    cidr_block = var.destinationCIDRblock
    from_port = 22
    to_port = 22
    protocol = "tcp"
    rule_no = 100
  }

  # allow Egress port 80
  egress {
    action = "allow"
    cidr_block = var.destinationCIDRblock
    from_port = 80
    to_port = 80
    protocol = "tcp"
    rule_no = 200
  }

  tags = {
    Name = "Sandbox Main NACL"
    Category = "Sandbox"
  }
}

# Create Internet Gateway
#   not shown on VPC properties in AWS Console
resource "aws_internet_gateway" "Sandbox_IGW" {
  vpc_id = aws_vpc.Sandbox_VPC1.id

  tags = {
    Name = "Sandbox InternetGateway"
    Category = "Sandbox"
  }
}

# Create Route Table
resource "aws_route_table" "Sandbox_Main_RT" {
  vpc_id = aws_vpc.Sandbox_VPC1.id

  tags = {
    Name = "Sandbox Main RT"
    Category = "Sandbox"
  }
}

# Create Route entry in Sandbox_Main_RT
resource "aws_route" "Sandbox_Internet_Route" {
  route_table_id = aws_route_table.Sandbox_Main_RT.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id = aws_internet_gateway.Sandbox_IGW.id
}

# Associate Route Table(Sandbox_Main_RT) with Subnet
resource "aws_route_table_association" "Sandbox_RT_Subnet_association" {
  subnet_id = aws_subnet.Sandbox_Main_Subnet.id
  route_table_id = aws_route_table.Sandbox_Main_RT.id
}