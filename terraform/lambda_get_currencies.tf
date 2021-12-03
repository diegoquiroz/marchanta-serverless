/* Get currencies lambda */
data "archive_file" "lambda_get_currencies" {
  type = "zip"
  source_dir = "${path.module}/lambdas/get-currencies"
  output_path = "${path.module}/lambdas/get-currencies.zip"
}

resource "aws_s3_bucket_object" "lambda_get_currencies" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "get-currencies.zip"
  source = data.archive_file.lambda_get_currencies.output_path

  etag = filemd5(data.archive_file.lambda_get_currencies.output_path)
}

resource "aws_lambda_function" "lambda_get_currencies" {
  function_name = "MarchantaGetCurrencies"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_get_currencies.key

  runtime = "nodejs14.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.lambda_get_currencies.output_base64sha256

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
