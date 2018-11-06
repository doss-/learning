
#generic container for all the API Gateway objects that will be created
#(probably in lambda.tf)
resource "aws_api_gateway_rest_api" "example" {
  name = "ServerlessExample"
  description = "Terraform Serverless Application Example"
}
