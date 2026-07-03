resource "aws_api_gateway_rest_api" "todo_api" {
  name        = "todo-api"
  description = "Serverless Todo REST API"

  tags = {
    Project = "aws-serverless-todo-api"
  }
}

# /todos resource
resource "aws_api_gateway_resource" "todos" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  parent_id   = aws_api_gateway_rest_api.todo_api.root_resource_id
  path_part   = "todos"
}

# /todos/{id} resource
resource "aws_api_gateway_resource" "todo_id" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  parent_id   = aws_api_gateway_resource.todos.id
  path_part   = "{id}"
}

# POST /todos
resource "aws_api_gateway_method" "post_todo" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todos.id
  http_method   = "POST"
  authorization = "NONE"
}

# GET /todos
resource "aws_api_gateway_method" "get_todos" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todos.id
  http_method   = "GET"
  authorization = "NONE"
}

# GET /todos/{id}
resource "aws_api_gateway_method" "get_todo" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todo_id.id
  http_method   = "GET"
  authorization = "NONE"
}

# PUT /todos/{id}
resource "aws_api_gateway_method" "put_todo" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todo_id.id
  http_method   = "PUT"
  authorization = "NONE"
}

# DELETE /todos/{id}
resource "aws_api_gateway_method" "delete_todo" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todo_id.id
  http_method   = "DELETE"
  authorization = "NONE"
}

# Lambda integrations
resource "aws_api_gateway_integration" "post_todo" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.todos.id
  http_method             = aws_api_gateway_method.post_todo.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.todo_api.invoke_arn
}

resource "aws_api_gateway_integration" "get_todos" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.todos.id
  http_method             = aws_api_gateway_method.get_todos.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.todo_api.invoke_arn
}

resource "aws_api_gateway_integration" "get_todo" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.todo_id.id
  http_method             = aws_api_gateway_method.get_todo.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.todo_api.invoke_arn
}

resource "aws_api_gateway_integration" "put_todo" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.todo_id.id
  http_method             = aws_api_gateway_method.put_todo.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.todo_api.invoke_arn
}

resource "aws_api_gateway_integration" "delete_todo" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.todo_id.id
  http_method             = aws_api_gateway_method.delete_todo.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.todo_api.invoke_arn
}

# Lambda permission for API Gateway
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.todo_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.todo_api.execution_arn}/*/*"
}

# API Deployment
resource "aws_api_gateway_deployment" "todo_api" {
  depends_on = [
    aws_api_gateway_integration.post_todo,
    aws_api_gateway_integration.get_todos,
    aws_api_gateway_integration.get_todo,
    aws_api_gateway_integration.put_todo,
    aws_api_gateway_integration.delete_todo
  ]

  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  stage_name  = "dev"
}