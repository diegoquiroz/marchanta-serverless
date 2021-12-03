/* Get order_has_products lambda */
data "archive_file" "lambda_get_order_has_products" {
  type = "zip"
  source_dir = "${path.module}/lambdas/get-order_has_products"
  output_path = "${path.module}/lambdas/get-order_has_products.zip"
}

resource "aws_s3_bucket_object" "lambda_get_order_has_products" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "get-order_has_products.zip"
  source = data.archive_file.lambda_get_order_has_products.output_path

  etag = filemd5(data.archive_file.lambda_get_order_has_products.output_path)
}

resource "aws_lambda_function" "lambda_get_order_has_products" {
  function_name = "MarchantaGetOrderHasProducts"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_get_order_has_products.key

  runtime = "nodejs14.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.lambda_get_order_has_products.output_base64sha256

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

