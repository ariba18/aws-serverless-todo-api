data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/todo.py"
  output_path = "${path.module}/../lambda/todo.zip"
}

resource "aws_lambda_function" "todo_api" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "todo.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }

  tags = {
    Name        = "todo-api-lambda"
    Environment = "dev"
    Project     = "aws-serverless-todo-api"
  }
}