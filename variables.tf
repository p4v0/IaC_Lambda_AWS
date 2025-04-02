# Variables generales
variable "profile_name" {
  description = "Nombre del perfil de AWS a usar"
  type        = string
  #default     = "nombre_perfil" # No es necesario definirlo acá si se define en .tfvars (por seguridad, ya que .tfvars no se sube al repo)
}

# Variables lambda
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

# Variables EventBridge Scheduler
#variable "scheduler_name" # No se define acá scheduler_name ya que se forma con base en otra variable (lambda_name) y las variables no pueden referenciar a otras en su valor default
                              # se usa locals.tf en este caso

variable "cron_expression" {
  description = "Expresión cron para la ejecución del Lambda con EventBridge Scheduler"
  type        = string
  default     = "cron(2 0 2 * ? *)" # 1:05 AM día 2 del mes de todos los meses de todos los años: la hora debe estar en formato 24 horas sin ceros a la izquierda.
                                      # cron(MIN HORA DOM MES DOW AÑO), DOM: DayOfMonth, DOW: DayOfWeek
}

variable "cron_expression_timezone" {
  description = "Zona horaria para la ejecución del Lambda con EventBridge Scheduler"
  type        = string
  default     = "America/Bogota" # UTC-5 (Colombia)
}

variable "scheduler_tags" {
  description = "Tags para el EventBridge Schedule y su rol"
  type        = map(string)
  default = {
    Environment = "Dev"
    Solucion     = "EventBridge_Schedule_con_Terraform"
    Creador     = "PavonIA"
    fecha_creacion  = "1/4/25"

  }
}