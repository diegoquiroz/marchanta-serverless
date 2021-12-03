resource "aws_api_gateway_deployment" "dev" {
  rest_api_id = aws_api_gateway_rest_api.Marchanta.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.Marchanta.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.dev.id
  rest_api_id   = aws_api_gateway_rest_api.Marchanta.id
  stage_name    = "dev"
}

resource "aws_api_gateway_method_settings" "method" {
  rest_api_id = aws_api_gateway_rest_api.Marchanta.id
  stage_name  = aws_api_gateway_stage.dev.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
  }
}
