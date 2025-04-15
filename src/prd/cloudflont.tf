resource "aws_cloudfront_distribution" "tech_vista_cfront" {
  enabled = true
  default_root_object = "index.html"

  origin {
    origin_id                = aws_s3_bucket.tech_vista.id
    domain_name              = aws_s3_bucket.tech_vista.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.tech_vista_oac.id
  }

  viewer_certificate {
    
    # CloudFlontのデフォルトSSL証明書使う
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.tech_vista.id
    viewer_protocol_policy = "redirect-to-https"
    cached_methods         = ["GET", "HEAD"]
    allowed_methods        = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "tech_vista_oac" {
  name                              = aws_s3_bucket.tech_vista.bucket_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

output "cfront_domain_name" {
  value = aws_cloudfront_distribution.tech_vista_cfront.domain_name
}
