resource "aws_api_gateway_rest_api" "raspberry" {
  body = jsonencode(
    {
      "openapi" : "3.0.1",
      "info" : {
        "title" : "raspberry",
        "version" : "1.0"
      },
      "servers" : [ {
        "url" : "https://3ftss2zfz4.execute-api.ap-northeast-1.amazonaws.com/{basePath}",
        "variables" : {
          "basePath" : {
            "default" : "/raspberry_stage"
          }
        }
      } ],
      "paths" : {
        "/path1" : {
          "get" : {
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "GET",
              "uri" : "https://ip-ranges.amazonaws.com/ip-ranges.json",
              "passthroughBehavior" : "when_no_match",
              "type" : "http_proxy"
            }
          }
        }
      },
      "components" : { },
      "x-amazon-apigateway-binary-media-types" : [ "*/*" ]
    }
  )

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
