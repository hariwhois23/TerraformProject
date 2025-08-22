variable "vpc_cidr" {
  description = "The cidr range for the VPC"
  type        = string
}

variable "subnet_vpc" {
  description = "The subnet CIDR range for the instance"
  type        = list(string) #since there are two subnets

}