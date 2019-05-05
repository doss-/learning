data "aws_iam_policy_document" "iot_policy_sensors" {
  statement {
    #TODO: for some reason after creation it has sid:""
    effect = "Allow"
    actions = ["iot:Publish"]
    resources = ["arn:aws:iot:${var.region}:&{aws:userid}:topic/${var.MQTTSensorsTopicName}/+"]
  }
}

data "aws_iam_policy_document" "iot_policy_rssi" {
  statement {
    #TODO: for some reason after creation it has sid:""
    effect = "Allow"
    actions = ["iot:Publish"]
    resources = ["arn:aws:iot:${var.region}:&{aws:userid}:topic/${var.MQTTRSSITopicName}/+"]
  }
}

data "aws_caller_identity" "current" {}

