variable domain_name {
    description = "Domain name"
    default = "www.fotopie.zqwang.net"
}

variable "hosted_zone_name" {
  description = "hosted zone domain name"
  default = "zqwang.net"
}

variable "main_region" {
    description = "Main region for AWS resources"
    default = "ap-southeast-2"
  
}

variable "acm_region" {
    description = "Region for ACM"
    default = "us-east-1"
  
}
variable "bucket_name" {
    description = "Namnr of traget S3 bucket"
    default = "www.fotopie.zqwang.net"
  
}

variable "default_vpc_id" {
    description = "ID of default VPC"
    default = "vpc-04936b1b1afaf216b"
  
}