variable "vpc_cidr" {
  description = "The cidr range for the VPC"
  type        = string
}


variable "subnet_vpc" {
    description = "The subnet CIDR range for the instance"
    type = list(string) #since there are two subnets
     
  
}

variable "subnet_names" {
    description = "name of the subnet"
    type = list(string)
    default = [ "Publicsubnet-1", "Publicsubnet-2" ]
  
}