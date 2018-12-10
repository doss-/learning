variable "region" {
  description="TBD"
}

variable "MQTTSensorsTopicName" {
  default = "sensorsTopic"
}

#VARIABLES END

provider "aws" {
  region="${var.region}"
}

data "aws_iam_policy_document" "iot_policy_sensors" {
  statement {
    #TODO: for some reason after creation it has sid:""
    effect = "Allow"
    actions = ["iot:Publish"]
    resources = ["arn:aws:iot:${var.region}:&{aws:userid}:topic/${var.MQTTSensorsTopicName}/+"]
  }
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

output "certificate_arn" {
  value = "${aws_iot_certificate.certificate_1.arn}"
}
