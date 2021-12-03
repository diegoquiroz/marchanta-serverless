/* Get Orders */
data "archive_file" "lambda_post_order" {
  type = "zip"
  source_dir = "${path.module}/lambdas/post-order"
  output_path = "${path.module}/lambdas/post-order.zip"
}

resource "aws_s3_bucket_object" "lambda_post_order" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "post-order.zip"
  source = data.archive_file.lambda_post_order.output_path

  etag = filemd5(data.archive_file.lambda_post_order.output_path)
}

resource "aws_lambda_function" "lambda_post_order" {
  function_name = "MarchantaPostOrder"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_post_order.key

  runtime = "nodejs14.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.lambda_post_order.output_base64sha256

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

resource "aws_api_gateway_method" "PostOrder" {
  rest_api_id   = aws_api_gateway_rest_api.Marchanta.id
  resource_id   = aws_api_gateway_resource.Orders.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "PostOrderIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.Marchanta.id
  resource_id             = aws_api_gateway_resource.Orders.id
  http_method             = aws_api_gateway_method.PostOrder.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_post_order.invoke_arn
}

resource "aws_lambda_permission" "PostOrderPermission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_post_order.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.Marchanta.execution_arn}/*/*"
}
