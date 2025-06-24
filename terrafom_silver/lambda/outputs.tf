output "lambda_name" {
  description = "Nom de la fonction Lambda"
  value       = aws_lambda_function.this.function_name
}

output "lambda_arn" {
  description = "ARN complet de la Lambda"
  value       = aws_lambda_function.this.arn
}
