# Preconf Terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.93.0"  # Asegura una ver. reciente https://registry.terraform.io/providers/hashicorp/aws/latest
    }
  }
}

# Preconf AWS provider
provider "aws" {
  region  = "us-east-1"
  # el perfil a usar en mi .config  
  # recordar iniciar sesión en SSO para este perfil desde la cli: aws sso login --profile nombre_perfil
  profile = var.profile_name
}

# Rol para el lambda
resource "aws_iam_role" "lambda_role" {
  name = "Rol_${var.lambda_name}"

  assume_role_policy = jsonencode({
 
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
					
        Principal = { Service = "lambda.amazonaws.com" }
		
        Effect    = "Allow"
      }
    ]
  })
  # Agregar las etiquetas
  tags = var.lambda_tags
}

# Política para el rol
resource "aws_iam_policy" "Politica_lambda_basic_exec_role" {
  name        = "Politica_lambda_basic_exec_role_${var.lambda_name}"
  description = "Permiso básico de Lambda para que escriba logs en CloudWatch"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "logs:CreateLogGroup"
        Resource = "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:*"
      },
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda_name}:*"
      }
    ]
  })
}

# attach política al rol (lambda)
resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.Politica_lambda_basic_exec_role.arn
}

# lambda
resource "aws_lambda_function" "mi_lambda" {
  function_name = var.lambda_name
  runtime       = var.lambda_runtime
  handler       = var.lambda_handler
  filename      = "lambda.zip" # crear un lambda.zip en la raíz del proyecto ya que este argumento es obligatorio, luego se puede subir el .zip real con un Worflow de CD
  role          = aws_iam_role.lambda_role.arn
  timeout       = 10 # opcional, timeout del lambda
  tags          = var.lambda_tags
}

data "aws_caller_identity" "current" {} # obetener ID de cuenta actual dinámicamente
