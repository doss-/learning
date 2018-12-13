variable "region" {
  description="TBD"
}

variable "MQTTSensorsTopicName" {
  default = "sensorsTopic"
}

#will use default profile from credentials file if none explicitly specified 
variable "profile" {
  description = "profile from under which Terraform operates"
}

#seems that shared_credentials_file is checked against default location
#where i have it
#but anyway it is always better to point it out explicitly
variable "shared_credentials_file" {
  description = "path for credentials file"
}

#VARIABLES END

provider "aws" {
  region="${var.region}"
  shared_credentials_file = "${var.shared_credentials_file}"
  profile = "${var.profile}"
}

data "aws_iam_policy_document" "iot_policy_sensors" {
  statement {
    #TODO: for some reason after creation it has sid:""
    effect = "Allow"
    actions = ["iot:Publish"]
    resources = ["arn:aws:iot:${var.region}:&{aws:userid}:topic/${var.MQTTSensorsTopicName}/+"]
  }
}

#RESOURCES START

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

resource "aws_iot_certificate" "certificate_1" {
  active = true
  csr = "${file("keys/iot_device.crt")}"
}

resource "aws_iot_policy_attachment" "attach_policy_to_cert" {
  policy = "${aws_iot_policy.sensorsPolicy.name}"
  target = "${aws_iot_certificate.certificate_1.arn}"
}

resource "aws_iot_topic_rule" "RSSIRule" {
  name = "RSSIRule"
  description = "rule to handle RSSI"
  enabled = true
  sql_version = "2015-10-08"
  sql = "SELECT * FROM 'RSSI/+'"

  #call lambda Process RSSI

  #need to call iotAnalytics, but terraform does not have yet
  #probably need to edit rule manually over some script
  #better to call script somehow in scope of terraform
  #need to find out how to call script by terraform
}

resource "aws_iot_topic_rule" "OverstressRule" {
  name = "OverstressRule"
  description = "rule to handle Overstress"
  enabled = true
  sql_version = "2015-10-08"
  sql = "SELECT * FROM 'sensors/+'"

  #call lambda Process Overstress

  #also need to call iotAnalytics
}

resource "aws_iot_topic_rule" "SensorsRule" {
  name = "SensorsRule"
  description = "rule to call Sensors"
  enabled = true
  sql_version = "2015-10-08"
  sql = "SELECT * FROM 'sensors/+'"

  #call lambda ProcessSensors

  #also need to call iotAnalytics
}


output "certificate_arn" {
  value = "${aws_iot_certificate.certificate_1.arn}"
}
