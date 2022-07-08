resource "aws_api_gateway_rest_api" "raspberry" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "raspberry"
      version = "1.0"
    }
    paths = {
      "/path1" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
  })

  name = "raspberry"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "raspberry_deployment" {
  rest_api_id = aws_api_gateway_rest_api.raspberry.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.raspberry.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "raspberry_stage" {
  deployment_id = aws_api_gateway_deployment.raspberry_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.raspberry.id
  stage_name    = "raspberry_stage"
}
