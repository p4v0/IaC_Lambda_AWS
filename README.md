# IaC_Lambda_AWS
1/4/25 cpavonIA/p4v0 IaC en Terraform para crear una lambda básica con el permiso básico de ejecución (logs de Cloudwatch)

## Nota, se provee un .zip dummy para que pueda crearse la lambda ya que es obligatorio especificar el código, se creó así (PowerShell):
### 1. Crear carpeta temporal
New-Item -ItemType Directory -Path lambda_code

### 2. Crear el archivo Python con el código de ejemplo
@"
import json

def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
"@ | Out-File -Encoding utf8 lambda_code/main.py

### 3. Crear el ZIP con el código dentro
Compress-Archive -Path lambda_code\* -DestinationPath lambda.zip -Force

### 4. Eliminar carpeta temporal
Remove-Item -Recurse -Force lambda_code

