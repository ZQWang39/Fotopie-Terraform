
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name =  module.s3-bucket.s3_bucket_bucket_regional_domain_name
    origin_id = module.s3-bucket.s3_bucket_website_endpoint
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [var.domain_name]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = module.s3-bucket.s3_bucket_website_endpoint

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["AU"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}

output "domain_name"{
    value = module.s3-bucket.s3_bucket_bucket_regional_domain_name
}
//domain_name = "www.fotopie.zqwang.net.s3.ap-southeast-2.amazonaws.com

output "origin_id"{
    value = module.s3-bucket.s3_bucket_website_endpoint
}
//www.fotopie.zqwang.net.s3-website-ap-southeast-2.amazonaws.com
