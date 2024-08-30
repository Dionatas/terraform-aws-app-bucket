variable "nome_do_sistema" {
  description = "Nome do sistema ou modulo onde o bucket será utilizado. Vai ser usado como parte do nome do buclet."
}

variable "ambiente" {
  description = "Ambiente onde o bucket sera utilizado <dev|hmlg|prod>. Vai ser usado como parte do nome do buclet."
}

variable "enable_versioning" {
  description = "Define se o versionamento deve ser habilitado. Habilitado por padrão no ambiente prod"
  type        = string
  default     = "Disabled"
}