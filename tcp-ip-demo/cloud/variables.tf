# This file is for Declaration of variables ( see http://guidetojava.com/mydoc/5d_VariableInit.html)

variable "region" {
  type        = string
  description = "Region to use"
  default = "us-east-1"
}

variable "profile" {
  type        = string
  default = "terraform"
  description = "Profile to use. It should be in Shared file (~/.aws/credentials)"  
}

#  VPC spans on all AZ in Region
variable "availabilityZone" {
     default = "us-east-1a"
}

variable "instanceTenancy" {
    default = "default"
    description = "Always MUST be default because $$$"
}

# Docs: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html
variable "dnsSupport" {
    default = true
    description = "Enables Route 53 Resolver(169.254.169.253) which will server DNS names for Instances with Public IP"
}

# https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ip-addressing.html#vpc-public-ipv4-addresses
variable "dnsHostNames" {
    default = true
    description = "Creates DNS names for Instances with Public IP. DNS Name resolve in Public\\Private IP from Outside\\Inside"
}

# VPC Size and subnets: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html
# Secondary CIDRs: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html#vpc-resize
#    When you create a VPC, you must specify an IPv4 CIDR block for the VPC. 
#    The allowed block size is between a /16 netmask (65,536 IP addresses) and /28 netmask (16 IP addresses). 
#    After you've created your VPC, you can associate secondary CIDR blocks with the VPC. 
# ===============
#    The first four IP addresses and the last IP address in each subnet CIDR block are not available for you to use, and cannot be assigned to an instance. 
#    .0 - Net address
#    .1 - AWS Reserved VPC Router
#    .2 - AWS DNS (exists only in Main CIDR)
#    .3 - AWS Reserved for future use
#    .255 - Broadcast. AWS does not support it - probably Mocked
variable "vpcMainCIDRblock" {
    default = "172.20.0.0/16"
    description = "Required CIDR Block for VPC. No more than /16"
}

#    The CIDR block of a subnet can be the same as the CIDR block for the VPC (for a single subnet in the VPC), 
#    or a subset of the CIDR block for the VPC (for multiple subnets). 
#    The allowed block size is between a /28 netmask and /16 netmask. 
#    If you create more than one subnet in a VPC, the CIDR blocks of the subnets cannot overlap. 
variable "subnetCIDRblock" {
    default = "172.0.1.0/24"
    description = "Must be a subset of the VPC CIDR block"
}

#------------------------------
variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}

# TODO: add Virtual Private Gateway, and remove IGW
#       re-set back to default(false) 
variable "mapPublicIP" {
    default = true
}