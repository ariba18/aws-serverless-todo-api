variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "todos"
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "todo-api"
}