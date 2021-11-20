provider "aws" {
  region = "us-west-2"
}

resource "aws_dynamodb_table" "ddbtable" {
  name             = "orders"
  hash_key         = "id"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.role_for_LDC.id

  policy = file("policy.json")
}

resource "aws_iam_role" "role_for_LDC" {
  name = "myrole"

  assume_role_policy = file("assume_role_policy.json")

}

resource "aws_lambda_function" "myLambda" {
  function_name = "func"
  s3_bucket     = "mybucket98745"
  s3_key        = "index.zip"
  role          = aws_iam_role.role_for_LDC.arn
  handler       = "index.handler"
  runtime       = "nodejs12.x"
}
