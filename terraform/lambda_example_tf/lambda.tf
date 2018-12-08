variable "region" {
  description="region where create to"
}

variable "s3_bucket" {
  description="the bucket name"
}

variable "app_version" {
  description = "app version - dir name in s3"
}

#VARIABLES END

provider "aws" {
  region="${var.region}"  
}


resource "aws_lambda_function" "example" {
  function_name = "ServerlessExample"

  # bucket name and path inside it to the source code to be run in Lambda
  s3_bucket = "${var.s3_bucket}"
  s3_key = "lambda/v${var.app_version}/lambda_example.zip"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "main.handler"
  runtime = "nodejs6.10"

  role = "${aws_iam_role.lambda_exec.arn}"
}

#create role? wow much automation such happy

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#all incoming requests must match resource and its method 
#we gonna match all incoming requests:
# path_part:proxy+ - will match any request path - activating proxy mode
# http_method:Any - any request method is fine
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  parent_id = "${aws_api_gateway_rest_api.example.root_resource_id}"
  path_part = "{proxy+}"
}

#'method' belongs to 'resource'
resource "aws_api_gateway_method" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = "${aws_api_gateway_resource.proxy.id}"
  http_method = "ANY"
  authorization = "NONE"
}



#'integration' belongs to 'method'
#Routes matched requests into given Lambda
#Integration of type 'AWS_PROXY' causes API gateway to call into the API of 
# another AWS service
#In this case it will call AWS Lambda API to create invocation of the Lambda
# function 
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.example.invoke_arn}"
}

#this is some dumb workaround for empty path at the root of the API
#and it is linked right onto the main REST API container
resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = "${aws_api_gateway_rest_api.example.root_resource_id}"
  http_method = "ANY"
  authorization = "NONE"
}

#continuation of dumb stuff, this time integration
resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.example.invoke_arn}"
}

#activate the configuration and expose API at a URL that can be used
resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    "aws_api_gateway_integration.lambda",
    "aws_api_gateway_integration.lambda_root",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  stage_name = "test"
}

resource "aws_lambda_permission" "apigw" {
  statement_id = "AllowAPIGaewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.example.arn}"
  principal = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API"
  source_arn = "${aws_api_gateway_deployment.example.execution_arn}/*/*"
}

