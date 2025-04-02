# Usa locals cuando necesites valores derivados de otras variables dentro del código de Terraform
locals {
  scheduler_name = "EB_Schedule_${var.lambda_name}"
}
