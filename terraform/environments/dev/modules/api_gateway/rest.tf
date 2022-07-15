resource "aws_api_gateway_rest_api" "raspberry" {
  body = jsonencode(
    {
      "openapi" : "3.0.1",
      "info" : {
        "title" : "test",
        "version" : "2022-07-13T22:27:01Z"
      },
      "servers" : [ {
        "url" : "https://qm64459gac.execute-api.ap-northeast-1.amazonaws.com/{basePath}",
        "variables" : {
          "basePath" : {
            "default" : "/v1"
          }
        }
      } ],
      "paths" : {
        "/{folder}/{object}" : {
          "put" : {
            "parameters" : [ {
              "name" : "object",
              "in" : "path",
              "required" : true,
              "schema" : {
                "type" : "string"
              }
            }, {
              "name" : "folder",
              "in" : "path",
              "required" : true,
              "schema" : {
                "type" : "string"
              }
            } ],
            "responses" : {
              "200" : {
                "description" : "200 response",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/Empty"
                    }
                  }
                }
              }
            },
            "x-amazon-apigateway-integration" : {
              "credentials" : "${aws_iam_role.api.arn}",
              "httpMethod" : "PUT",
              "uri" : "arn:aws:apigateway:ap-northeast-1:s3:path/{bucket}/{key}",
              "responses" : {
                "default" : {
                  "statusCode" : "200"
                }
              },
              "requestParameters" : {
                "integration.request.path.key" : "method.request.path.object",
                "integration.request.path.bucket" : "method.request.path.folder"
              },
              "passthroughBehavior" : "when_no_match",
              "type" : "aws"
            }
          }
        }
      },
      "components" : {
        "schemas" : {
          "Empty" : {
            "title" : "Empty Schema",
            "type" : "object"
          }
        }
      },
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
