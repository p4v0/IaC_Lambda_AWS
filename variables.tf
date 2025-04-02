variable "profile_name" {
  description = "Nombre del perfil de AWS a usar"
  type        = string
  default     = "nombre_perfil" # nombre_perfil en .aws/config
}

variable "lambda_name" {
  description = "Nombre de la función Lambda"
  type        = string
  default     = "Lambda_con_terraform"
}

variable "lambda_runtime" {
  description = "Runtime de la función Lambda"
  type        = string
  default     = "python3.13"
}

variable "lambda_handler" {
  description = "Handler (función principal) de la función Lambda"
  type        = string
  default     = "main.lambda_handler"
}

variable "lambda_tags" {
  description = "Tags para la función Lambda y su rol"
  type        = map(string)
  default = {
    Environment = "Dev"
    Solucion     = "Lambda_con_Terraform"
    Creador     = "PavonIA"
    fecha_creacion  = "1/4/25"
    
  }
}
