resource "aws_s3_bucket" "this" {
  bucket = "${var.bucket_name}-${var.environment}"

  force_destroy = var.environment == "prod" ? false : true

  tags = {
    sistema  = var.bucket_name
    endpoint = "s3.sa-east-1.amazonaws.com"
  }
}

resource "aws_s3_bucket_versioning" "enable_versioning" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.environment == "prod" ? "Enabled" : var.enable_versioning
  }
}

resource "aws_iam_user" "srv_s3_user" {
  name = format("srv-%s", resource.aws_s3_bucket.this.bucket)

  tags = {
    sistema = var.bucket_name
  }
}

resource "aws_iam_access_key" "key_srv_s3_user" {
  user = aws_iam_user.srv_s3_user.name
}


resource "aws_iam_policy" "pol_rw_s3_app" {
  name        = "POL_RW_S3-${var.bucket_name}-${var.environment}"
  description = format(" Policy RW for %s", aws_s3_bucket.this.bucket)

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${resource.aws_s3_bucket.this.bucket}/*",
          "arn:aws:s3:::${resource.aws_s3_bucket.this.bucket}"
        ]
      },
    ]
  })

  tags = {
    sistema = var.environment
  }
}

resource "aws_iam_user_policy_attachment" "srv_s3_user_rw_to_s3" {
  user       = aws_iam_user.srv_s3_user.id
  policy_arn = aws_iam_policy.pol_rw_s3_app.arn
}