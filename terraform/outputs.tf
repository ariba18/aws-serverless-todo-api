output "api_url" {
  description = "Base URL of the Todo API"
  value       = "https://${aws_api_gateway_deployment.todo_api.rest_api_id}.execute-api.${var.aws_region}.amazonaws.com/dev"
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.todo_api.function_name
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.todos.name
}