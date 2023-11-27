resource "aws_s3_bucket" "bucket" {
    bucket_prefix = "static-www"
}

resource "aws_s3_bucket_ownership_controls" "bucket" {
    bucket = aws_s3_bucket.bucket.id
    rule {
        object_ownership = "BucketOwnerEnforced"
    }
}

/*
resource "aws_s3_bucket_acl" "bucket" {
    bucket = aws_s3_bucket.bucket.id
    acl = "private"
}
*/

resource "aws_s3_bucket_website_configuration" "bucket" {
    bucket = aws_s3_bucket.bucket.id
    index_document {
        suffix = "index.html"
    }
    error_document {
      key = "error.html"
    }
}

resource "aws_s3_bucket_policy" "bucket" {
    bucket = aws_s3_bucket.bucket.id
    policy = data.aws_iam_policy_document.static-www.json
}

data "aws_iam_policy_document" "static-www" {
    statement {
        sid = "Allow CloudFront"
        effect = "Allow"
        principals {
            type = "AWS"
            identifiers = [aws_cloudfront_origin_access_identity.static-www.iam_arn]
        }
        actions = [
            "s3:GetObject"
        ]
        resources = [
            "${aws_s3_bucket.bucket.arn}/*"
        ]
    }
}
