output "bucket_name" {
  description = "Nome do bucket criado."
  value       = aws_s3_bucket.this.bucket
}

output "endpoint" {
  description = "endpoint a ser usado como credencial de acesso ao bucket."
  value       = aws_s3_bucket.this.tags.endpoint
}

output "id" {
  description = "aws_access_key_id a ser usado como credencial de acesso ao bucket."
  value       = aws_iam_access_key.key_srv_s3_user.id
}

output "secret" {
  description = "aws_secret_access_key a ser usado como credencial de acesso ao bucket."
  value       = aws_iam_access_key.key_srv_s3_user.secret
  sensitive   = true
}

