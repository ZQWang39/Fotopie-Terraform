
terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.56.0"
    }
  }
  backend "s3" {
        bucket = "fotopie-state-file"
        key = "terraform.tfstate"
        region = "ap-southeast-2"
    }
}

//For the global
provider "aws" {
  region = var.main_region
}
// For ACM provisioning 
provider "aws" {
  alias  = "us-east-1"
  region = var.acm_region
}

module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.7.0"

   bucket = var.bucket_name
   acl    = "public-read"

   versioning = {
    enabled = true
  }
  # Allow deletion of non-empty bucket
   force_destroy = true
   # Enable Static website hosting, default page of the website is index.html
   website = {
    index_document = "index.html"
   }
   #set to `true` to use value of `policy` as bucket policy
   attach_policy = true

   policy = <<POLICY
   {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::www.fotopie.zqwang.net/*"
        }
    ]
}
POLICY

}