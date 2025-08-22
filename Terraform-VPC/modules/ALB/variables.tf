variable "sg_id" {
    description = "The SG id"
   type = string
}

variable "subnets" {
    description = "Subnets for ALB"
  
}

variable "vpc_id" {
    description = "ID of the vpc"
  type = string
}

variable "instances" {
    description = "instance id for target group attachment"
    type = list(string)
  
}