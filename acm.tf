
// Create a SSL certificate,CloudFront supports US East (N. Virginia) Region only.
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "4.3.2"

  providers = {
  aws = aws.us-east-1
  }
  domain_name  = var.domain_name
  zone_id      = aws_route53_zone.domain.zone_id

  subject_alternative_names = [
    var.domain_name,
  ]

  wait_for_validation = true

  
}




