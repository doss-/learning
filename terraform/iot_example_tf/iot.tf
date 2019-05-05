resource "aws_iot_thing_type" "eseal"{
  name = "e-seal"
  #the documentation is incorrect, it does not states that
  #'properties' map have to be used to wrap description and srchbl_attrs
  # see here:
  #https://github.com/terraform-providers/terraform-provider-aws/pull/3302/commits/9427513366c1664eb81ceed62c253167f133d39d
  properties {
    description = "e-seal device type"
    searchable_attributes = ["bd_addr","asset_number"] 
  }
}

resource "aws_iot_thing" "example" {
  name = "ExampleThing"
  thing_type_name = "${aws_iot_thing_type.eseal.name}"
}

resource "aws_iot_thing_principal_attachment" "attach_cert_to_thing" {
  principal = "${aws_iot_certificate.certificate_1.arn}"
  thing     = "${aws_iot_thing.example.name}"
}

resource "aws_iot_policy" "sensorsPolicy" {
  name = "SensorsPolicy"
  policy = "${data.aws_iam_policy_document.iot_policy_sensors.json}"
}

resource "aws_iot_policy" "rssiPolicy" {
  name = "RSSIPolicy"
  policy = "${data.aws_iam_policy_document.iot_policy_rssi.json}"
}

resource "aws_iot_certificate" "certificate_1" {
  active = true
  csr = "${file("keys/iot_device.crt")}"
}

resource "aws_iot_policy_attachment" "attach_policy_to_cert_sernsors" {
  policy = "${aws_iot_policy.sensorsPolicy.name}"
  target = "${aws_iot_certificate.certificate_1.arn}"
}

resource "aws_iot_policy_attachment" "attach_policy_to_cert_rssi" {
  policy = "${aws_iot_policy.rssiPolicy.name}"
  target = "${aws_iot_certificate.certificate_1.arn}"
}

resource "aws_iot_topic_rule" "RSSIRule" {
  name = "RSSIRule"
  description = "rule to handle RSSI"
  enabled = true
  sql_version = "2015-10-08"
  sql = "SELECT * FROM '${var.MQTTRSSITopicName}/+'"

  #call lambda Process RSSI
  lambda {
    function_arn = "${aws_lambda_function.rssi_lambda.arn}"
  }

  #need to call iotAnalytics, but terraform does not have yet
  #probably need to edit rule manually over some script
  #better to call script somehow in scope of terraform
  #need to find out how to call script by terraform

/*
  #call this in every Topic Rule created, that needs to communicate to
  #IoT Analytics too
  provisioner "local-exec" {
    command = "aws iot <create IoT analytics stuff here>"
  }

  seems like i can not update Topic Rule, neither from
  SDK https://docs.aws.amazon.com/sdkfornet/v3/apidocs/items/IoT/TReplaceTopicRuleRequest.html
  API https://docs.aws.amazon.com/iot/latest/apireference/API_ReplaceTopicRule.html
  CLI https://docs.aws.amazon.com/cli/latest/reference/iot/replace-topic-rule.html

  i can only Replace it, which seems to be totally useless in case of terraform.
  it seems that much easier would be provision whole Topic Rule using command
  line 'aws iot' in case of creation of something else related to IoT

!  Important! Topic Rule is linked only in Lambda COndition, which i cant 
   implement either. And if IAM will work out, probably will be linked there
   If will be linked in IAM , Replace could work our - i will know the ARN
   and will be able to link the Topic Rule, else probably will jsut
   create it as provisioning in whole

   here is the topic_rule sources in terraform aws provider:
https://github.com/terraform-providers/terraform-provider-aws/blob/master/aws/resource_aws_iot_topic_rule.go
*/
}

resource "aws_iot_topic_rule" "OverstressRule" {
  name = "OverstressRule"
  description = "rule to handle Overstress"
  enabled = true
  sql_version = "2015-10-08"
  sql = "SELECT * FROM '${var.MQTTSensorsTopicName}/+'"

  #call lambda Process Overstress
  lambda {
    function_arn = "${aws_lambda_function.overstress_lambda.arn}"
  }

  #also need to call iotAnalytics
}

resource "aws_iot_topic_rule" "SensorsRule" {
  name = "SensorsRule"
  description = "rule to call Sensors"
  enabled = true
  sql_version = "2015-10-08"
  sql = "SELECT * FROM '${var.MQTTSensorsTopicName}/+'"

  #call lambda ProcessSensors
  lambda {
    function_arn = "${aws_lambda_function.sensors_lambda.arn}"
  }

  #also need to call iotAnalytics
}

#LAMBDAS
resource "aws_lambda_function" "rssi_lambda" {
  function_name = "RSSI_Lambda"

  s3_bucket = "${var.s3_bucket}"
  s3_key = "lambda/iot_rssi_${var.rssi_ver}/rssi_example.zip"

  handler = "rssi_example.my_logging_handler"
  runtime = "python3.6"

  role = "${aws_iam_role.lambda_iot_vpc_role.arn}"
  environment {
      variables = {
          rethinkdb_user = "${var.rethinkdb_user}", 
          rethinkdb = "${var.rethinkdb}", 
          rethinkdb_name = "${var.rethinkdb_name}", 
          rethinkdb_password = "${var.rethinkdb_password}"
      }
  }
}

# allow triggering from IoT Topic Rule 
resource "aws_lambda_permission" "allow_iot_rssi" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.rssi_lambda.function_name}"
  principal     = "iot.amazonaws.com"
  source_account = "${data.aws_caller_identity.current.account_id}" 
  source_arn = "${aws_iot_topic_rule.RSSIRule.arn}"
}
/*
this is confgured w/o COndition section, where specific user and
TOpic Rule are mentioned, but in general it works
Terraform (and seems CloudFOrmation too) cant set it up
Need to do it manually or move all Function Policy into IAM
see here the main idea:
https://docs.aws.amazon.com/lambda/latest/dg/intro-permission-model.html#intro-permission-model-access-policy
Quote:
Instead of using a Lambda function policy, you can create another IAM role that grants the event sources (for example, Amazon S3 or DynamoDB) permissions to invoke your Lambda function. However, you might find that resource policies are easier to set up and make it easier for you to track which event sources have permissions to invoke your Lambda function. 
*/

resource "aws_lambda_function" "overstress_lambda" {
  function_name = "Overstress_Lambda"

  s3_bucket = "${var.s3_bucket}"
  s3_key = "lambda/iot_overstress_${var.overstress_ver}/overstress_example.zip"

  handler = "overstress_example.my_logging_handler"
  runtime = "python3.6"

  role = "${aws_iam_role.lambda_iot_vpc_role.arn}"
}

# allow triggering from IoT Topic Rule 
resource "aws_lambda_permission" "allow_iot_overstress" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.overstress_lambda.function_name}"
  principal     = "iot.amazonaws.com"
  source_account = "${data.aws_caller_identity.current.account_id}" 
  source_arn = "${aws_iot_topic_rule.OverstressRule.arn}"
}

resource "aws_lambda_function" "sensors_lambda" {
  function_name = "Sensors_Lambda"

  s3_bucket = "${var.s3_bucket}"
  s3_key = "lambda/iot_sensors_${var.sensors_ver}/sensors_example.zip"

  handler = "sensors_example.my_logging_handler"
  runtime = "python3.6"

  role = "${aws_iam_role.lambda_iot_vpc_role.arn}"

  environment {
      variables = {
          rethinkdb_user = "${var.rethinkdb_user}", 
          rethinkdb = "${var.rethinkdb}", 
          rethinkdb_name = "${var.rethinkdb_name}", 
          rethinkdb_password = "${var.rethinkdb_password}"
      }
  }
}

# allow triggering from IoT Topic Rule 
resource "aws_lambda_permission" "allow_iot_sensors" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sensors_lambda.function_name}"
  principal     = "iot.amazonaws.com"
  source_account = "${data.aws_caller_identity.current.account_id}" 
  source_arn = "${aws_iot_topic_rule.SensorsRule.arn}"
}

#IAM ROLE
resource "aws_iam_role" "lambda_iot_vpc_role" {
  name = "lambda_iot_vpc_role"

  assume_role_policy = <<POLICY
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
POLICY
}

#attach permissions for the role
resource "aws_iam_role_policy_attachment" "attachAWSIoTConfigAccess" {
  role = "${aws_iam_role.lambda_iot_vpc_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSIoTConfigAccess"
}

resource "aws_iam_role_policy_attachment" "attachAWSLambdaVPCAccessExecutionRole" {
  role = "${aws_iam_role.lambda_iot_vpc_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "attachAWSLambdaRole" {
  role = "${aws_iam_role.lambda_iot_vpc_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

resource "aws_iam_role" "rethink_db_lambda_vpc" {
  name = "rethink_db_lambda_vpc"

  assume_role_policy = <<POLICY
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
POLICY
}

/*
#API GATEWAY 
resource "aws_api_gateway_rest_api" "rest_api" {
  name = "HandHeld_Gateway"
}

resource "aws_api_gateway_resource" "resource" {
  path_part = "resource"
  parent_id = "${aws_api_gateway_rest_api.rest_api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}" 
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}" 
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "${aws_lambda_function.lambda.invoke_arn}"
}

#lambda for gateway api
resource "aws_lambda_function" "lambda" {
  function_name = "ServerlessExample"

  # bucket name and path inside it to the source code to be run in Lambda
  s3_bucket = "${var.s3_bucket}"
  s3_key = "lambda/v${var.app_version}/lambda_example.zip"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "main.handler"
  runtime = "nodejs6.10"

  role = "${aws_iam_role.rethink_db_lambda_vpc.arn}"

}
*/
# resource "aws_lambda_permission" "allow_apigw_provision" {
#  action = "lambda:InvokeFuncion"
#  function_name = "${aws_lambda_function.lambda.arn}"
#  principal = "apigateway.amazonaws.com"
#  source_arn = "${aws_api_gateway_deployment.example.execution_arn}/*/${aws_api_gateway_method.method.http_method} ${aws_api_gateway_resource.resource.path}"
#}


#OUTPUT
output "certificate_arn" {
  value = "${aws_iot_certificate.certificate_1.arn}"
}
