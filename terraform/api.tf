resource "aws_api_gateway_rest_api" "Marchanta" {
  name = "MarchantaREST"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_cloudwatch_log_group" "marchanta_api_gw" {
  name = "/aws/marchanta_api_gw/${aws_api_gateway_rest_api.Marchanta.name}"

  retention_in_days = 3
}
