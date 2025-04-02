# EventBridge scheduler
resource "aws_scheduler_schedule" "lambda_schedule" {
  name        = local.scheduler_name
  description = "Ejecuta la función Lambda según expresión cron"
  #tags        = var.scheduler_tags # esto debería funcionar segun documentación, pero nonas, no funciona
  schedule_expression          = var.cron_expression
  schedule_expression_timezone = var.cron_expression_timezone

  flexible_time_window {
    mode = "OFF" # Desactiva la ejecución en ventanas de tiempo
  }
  target {
    arn      = aws_lambda_function.mi_lambda.arn
    role_arn = aws_iam_role.scheduler_role.arn
    
    retry_policy {
       maximum_retry_attempts = 3  # Reintentos si falla el target 
       maximum_event_age_in_seconds = 3600  # Máximo 1 hora en lugar de 1 día (que es el default)
    }
  }
}

# Rol para EB Scheduler
resource "aws_iam_role" "scheduler_role" {
  name = "Rol_${local.scheduler_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "${data.aws_caller_identity.current.account_id}"
          }
        }
      }
    ]
  })
  # Agregar las etiquetas
  tags = var.scheduler_tags
}

# Política para EB Scheduler
resource "aws_iam_policy" "Politica_scheduler" {
  name        = "Politica_exec_${local.scheduler_name}"
  description = "Permite que EventBridge Scheduler invoque la Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:InvokeFunction"
        Resource = [
          aws_lambda_function.mi_lambda.arn,
          "${aws_lambda_function.mi_lambda.arn}:*"
        ]
      }
    ]
  })
}

# attach política al rol (EB)
resource "aws_iam_role_policy_attachment" "attach_scheduler_lambda" {
  role       = aws_iam_role.scheduler_role.name
  policy_arn = aws_iam_policy.Politica_scheduler.arn
}

