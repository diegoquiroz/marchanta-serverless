resource "aws_api_gateway_rest_api" "Marchanta" {
  name = "MarchantaREST"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
resource "aws_api_gateway_resource" "Marchanta" {
  rest_api_id = aws_api_gateway_rest_api.Marchanta.id
  parent_id   = aws_api_gateway_rest_api.Marchanta.root_resource_id
  path_part   = "orders"
}

resource "aws_api_gateway_method" "GetMethod" {
  rest_api_id   = aws_api_gateway_rest_api.Marchanta.id
  resource_id   = aws_api_gateway_resource.Marchanta.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "MyDemoIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.Marchanta.id
  resource_id             = aws_api_gateway_resource.Marchanta.id
  http_method             = aws_api_gateway_method.GetMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_get_orders.invoke_arn
}

/* Get Orders */

resource "aws_cloudwatch_log_group" "marchanta_api_gw" {
  name = "/aws/marchanta_api_gw/${aws_api_gateway_rest_api.Marchanta.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "marchanta_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_get_orders.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.Marchanta.execution_arn}/*/*"
}
