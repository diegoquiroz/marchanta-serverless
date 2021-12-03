/* Delete order_has_product lambda */
data "archive_file" "lambda_delete_order_has_product" {
  type = "zip"
  source_dir = "${path.module}/lambdas/delete-order_has_product"
  output_path = "${path.module}/lambdas/delete-order_has_product.zip"
}

resource "aws_s3_bucket_object" "lambda_delete_order_has_product" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "delete-order_has_product.zip"
  source = data.archive_file.lambda_delete_order_has_product.output_path

  etag = filemd5(data.archive_file.lambda_delete_order_has_product.output_path)
}

resource "aws_lambda_function" "lambda_delete_order_has_product" {
  function_name = "MarchantaDeleteOrderHasProduct"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_delete_order_has_product.key

  runtime = "nodejs14.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.lambda_delete_order_has_product.output_base64sha256

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
resource "aws_api_gateway_resource" "DeleteOrderHasProduct" {
  rest_api_id = aws_api_gateway_rest_api.Marchanta.id
  parent_id   = aws_api_gateway_resource.OrderHasProducts.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "DeleteOrderHasProduct" {
  rest_api_id   = aws_api_gateway_rest_api.Marchanta.id
  resource_id   = aws_api_gateway_resource.DeleteOrderHasProduct.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "OrderHasProductIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.Marchanta.id
  resource_id             = aws_api_gateway_resource.DeleteOrderHasProduct.id
  http_method             = aws_api_gateway_method.DeleteOrderHasProduct.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_delete_order_has_product.invoke_arn
}

resource "aws_lambda_permission" "OrderHasProductPermission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_delete_order_has_product.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.Marchanta.execution_arn}/*/*"
}
