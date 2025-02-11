# S3 bucket for main website
resource "aws_s3_bucket" "main" {
  
  
  bucket = "${var.website_name}"
}

resource "aws_s3_bucket_website_configuration" "main" {
  
  
  bucket = aws_s3_bucket.main.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  
  
  bucket = aws_s3_bucket.main.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "main" {
  
  
  bucket = aws_s3_bucket.main.id
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
  
  
  bucket = "www.${var.website_name}"
}

resource "aws_s3_bucket_website_configuration" "www" {
  
  
  bucket = aws_s3_bucket.www.id

  redirect_all_requests_to {
    host_name = "${var.website_name}"
    protocol  = "https"
  }
}
resource "aws_s3_bucket_public_access_block" "www" {
  
  
  bucket = aws_s3_bucket.www.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "www" {
  
  
  bucket = aws_s3_bucket.www.id
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
