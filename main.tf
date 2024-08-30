resource "aws_s3_bucket" "s3_app_bucket" {
  bucket = format("%s-bucket-%s", var.nome_do_sistema, var.ambiente)

  force_destroy = var.ambiente == "prod" ? false : true

  tags = {
    sistema  = var.nome_do_sistema
    endpoint = "s3.sa-east-1.amazonaws.com"
  }
}

resource "aws_s3_bucket_versioning" "enable_versioning" {
  bucket = aws_s3_bucket.s3_app_bucket.id
  versioning_configuration {
    status = var.ambiente == "prod" ? "Enabled" : var.enable_versioning
  }
}

resource "aws_iam_user" "srv_s3_user" {
  name = format("srv-%s", resource.aws_s3_bucket.s3_app_bucket.bucket)

  tags = {
    sistema = var.nome_do_sistema
  }
}

resource "aws_iam_access_key" "key_srv_s3_user" {
  user = aws_iam_user.srv_s3_user.name
}

resource "aws_iam_policy" "pol_rw_s3_app" {
  name        = format("%s-POL_RW_S3-%s", var.nome_do_sistema, var.ambiente)
  description = format(" Policy RW for %s", aws_s3_bucket.s3_app_bucket.bucket)

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
          "arn:aws:s3:::${resource.aws_s3_bucket.s3_app_bucket.bucket}/*",
          "arn:aws:s3:::${resource.aws_s3_bucket.s3_app_bucket.bucket}"
        ]
      },
    ]
  })

  tags = {
    sistema = var.nome_do_sistema
  }
}

resource "aws_iam_user_policy_attachment" "srv_s3_user_rw_to_s3" {
  user       = aws_iam_user.srv_s3_user.id
  policy_arn = aws_iam_policy.pol_rw_s3_app.arn
}