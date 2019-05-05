variable "region" {
  description="TBD"
}

variable "MQTTSensorsTopicName" {
  default = "sensors"
}

variable "MQTTRSSITopicName" {
  default = "RSSI"
}

variable "rethinkdb_user" {
  default = "eseal"
}

variable "rethinkdb" {
  default = "172.31.34.156"
}

variable "rethinkdb_name" {
  default = "eseal"
}

variable "rethinkdb_password" {
  default = "eseal"
}

variable "rssi_ver" {
  description = "rssi lambda source version - dir name in s3"
}

variable "overstress_ver" {
  description = "overstress lambda source version - dir name in s3. upload it manually: aws s3 cp overstress_example.zip s3://dos-deepdive/lambda/iot_overstress_0.1/"
}

variable "sensors_ver" {
  description = "overstress lambda source version - dir name in s3. upload it manually: aws s3 cp overstress_example.zip s3://dos-deepdive/lambda/iot_overstress_0.1/"
}

variable "app_version" {
  description = "path part to s3 storage of zipped sources"
}

variable "s3_bucket" {
  description = "bucket to download sources from"
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

