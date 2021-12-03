/* Get Orders */
data "archive_file" "lambda_get_orders" {
  type = "zip"
  source_dir = "${path.module}/lambdas/get-orders"
  output_path = "${path.module}/lambdas/get-orders.zip"
}

resource "aws_s3_bucket_object" "lambda_get_orders" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "get-orders.zip"
  source = data.archive_file.lambda_get_orders.output_path

  etag = filemd5(data.archive_file.lambda_get_orders.output_path)
}

resource "aws_lambda_function" "lambda_get_orders" {
  function_name = "MarchantaGetOrders"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_get_orders.key

  runtime = "nodejs14.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.lambda_get_orders.output_base64sha256

  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      DB_NAME = "postgres"
      DB_USER = aws_db_instance.marchanta.username
      DB_PASS = aws_db_instance.marchanta.password
      DB_HOST = aws_db_instance.marchanta.address
      DB_PORT = aws_db_instance.marchanta.port
    }
  }
}


/* API Gateway */
resource "aws_api_gateway_resource" "Orders" {
  rest_api_id = aws_api_gateway_rest_api.Marchanta.id
  parent_id   = aws_api_gateway_rest_api.Marchanta.root_resource_id
  path_part   = "orders"
}

resource "aws_api_gateway_method" "GetOrders" {
  rest_api_id   = aws_api_gateway_rest_api.Marchanta.id
  resource_id   = aws_api_gateway_resource.Orders.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "OrdersIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.Marchanta.id
  resource_id             = aws_api_gateway_resource.Orders.id
  http_method             = aws_api_gateway_method.GetOrders.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_get_orders.invoke_arn
}

resource "aws_lambda_permission" "OrdersPermission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_get_orders.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.Marchanta.execution_arn}/*/*"
}
