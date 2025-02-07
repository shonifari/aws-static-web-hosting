# S3 bucket for main website
resource "aws_s3_bucket" "main" {
  count             = var.enable_cert_validation ? 1 : 0
  provider = aws.main
  bucket = "${var.website_name}"
}

resource "aws_s3_bucket_website_configuration" "main" {
  count             = var.enable_cert_validation ? 1 : 0
  provider = aws.main
  bucket = aws_s3_bucket.main[count.index].id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  count             = var.enable_cert_validation ? 1 : 0
  provider = aws.main
  bucket = aws_s3_bucket.main[count.index].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "main" {
  count             = var.enable_cert_validation ? 1 : 0
  provider = aws.main
  bucket = aws_s3_bucket.main[count.index].id
  depends_on = [aws_s3_bucket_public_access_block.main]
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.website_name}/*"
      }
    ]
  })
}

# S3 bucket for www subdomain (redirect)
resource "aws_s3_bucket" "www" {
  count             = var.enable_cert_validation ? 1 : 0
  provider = aws.main
  bucket = "www.${var.website_name}"
}

resource "aws_s3_bucket_website_configuration" "www" {
  count             = var.enable_cert_validation ? 1 : 0
  provider = aws.main
  bucket = aws_s3_bucket.www[count.index].id

  redirect_all_requests_to {
    host_name = "${var.website_name}"
    protocol  = "https"
  }
}
resource "aws_s3_bucket_public_access_block" "www" {
  count             = var.enable_cert_validation ? 1 : 0
  provider = aws.main
  bucket = aws_s3_bucket.www[count.index].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "www" {
  count             = var.enable_cert_validation ? 1 : 0
  provider = aws.main
  bucket = aws_s3_bucket.www[count.index].id
  depends_on = [aws_s3_bucket_public_access_block.www]
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::www.${var.website_name}/*"
      }
    ]
  })
}
