locals {
  bucket_name = "tech-vista"
}

resource "aws_s3_bucket" "tech_vista" {
  bucket = local.bucket_name
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.tech_vista.id
  key    = "index.html"
  source = "./index.html"
}

resource "aws_s3_bucket_policy" "policy" {
  depends_on = [
    aws_s3_bucket.tech_vista,
  ]
  bucket = aws_s3_bucket.tech_vista.id
  policy = data.aws_iam_policy_document.policy_document.json
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.tech_vista.arn,
      "${aws_s3_bucket.tech_vista.arn}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.tech_vista_cfront.arn]
    }
  }
}
