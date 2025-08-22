variable "sg_id" {
  description = "The id of the security group"
  type        = string
}

variable "subnets" {
  description = "The subnet that has to be associated with"
  type        = list(string)

}

variable "EC2_names" {
  description = "The name for the ec2 instances "
  type        = list(string)
  default     = ["Webserver1", "Webserver2"]

}
