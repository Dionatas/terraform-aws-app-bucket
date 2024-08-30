variable "environment" {
  description = "Set the environment that will be used"
  type        = string
}


variable "bucket_name" {
  description = "Set the bucket name that will be used"
  type        = string
}


variable "enable_versioning" {
  description = "Define se o versionamento deve ser habilitado. Habilitado por padrão no ambiente prod"
  type        = string
  default     = "Disabled"
}