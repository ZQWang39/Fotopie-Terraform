
resource "aws_route53_zone" "domain" {
  name = var.hosted_zone_name
  force_destroy = false
}

//Create a hosted zone
resource "aws_route53_record" "fotopie" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = var.domain_name
  type    = "A"
  # alias {
  #   name                   = module.s3-bucket.s3_bucket_website_endpoint 
  #   zone_id                = module.s3-bucket.s3_bucket_hosted_zone_id
  #   evaluate_target_health = true
  # }
  // Pointing CF reources instead 

   alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
  
}

// Update the NS record of the new hosted zone to registered domain

resource "aws_route53domains_registered_domain" "zqwang_net" {
  domain_name = var.hosted_zone_name

  name_server {
    name = aws_route53_zone.domain.name_servers[0]
  }

  name_server {
    name = aws_route53_zone.domain.name_servers[1]
  }

   name_server {
    name = aws_route53_zone.domain.name_servers[2]
  }

   name_server {
    name = aws_route53_zone.domain.name_servers[3]
  }

}

output "name_servers" {
    value = aws_route53_zone.domain.name_servers
  
}