/* Get Payment Methods */
data "archive_file" "lambda_get_payment_methods" {
  type = "zip"
  source_dir = "${path.module}/lambdas/get-payment_methods"
  output_path = "${path.module}/lambdas/get-payment_methods.zip"
}

resource "aws_s3_bucket_object" "lambda_get_payment_methods" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "get-payment_methods.zip"
  source = data.archive_file.lambda_get_payment_methods.output_path

  etag = filemd5(data.archive_file.lambda_get_payment_methods.output_path)
}

resource "aws_lambda_function" "lambda_get_payment_methods" {
  function_name = "MarchantaGetPaymentMethods"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_get_payment_methods.key

  runtime = "nodejs14.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.lambda_get_payment_methods.output_base64sha256

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
resource "aws_api_gateway_resource" "PaymentMethods" {
  rest_api_id = aws_api_gateway_rest_api.Marchanta.id
  parent_id   = aws_api_gateway_rest_api.Marchanta.root_resource_id
  path_part   = "payment-methods"
}

resource "aws_api_gateway_method" "GetPaymentMethods" {
  rest_api_id   = aws_api_gateway_rest_api.Marchanta.id
  resource_id   = aws_api_gateway_resource.PaymentMethods.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "PaymentMethodsIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.Marchanta.id
  resource_id             = aws_api_gateway_resource.PaymentMethods.id
  http_method             = aws_api_gateway_method.GetPaymentMethods.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_get_payment_methods.invoke_arn
}

resource "aws_lambda_permission" "PaymentMethodsPermission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_get_payment_methods.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.Marchanta.execution_arn}/*/*"
}
