variable "region" {
  default = "eu-central-1"
}

variable "vpc_cidr" {
  default = "192.168.0.0/16"
}

variable "subnet_cidr" {
  default = "192.168.1.0/24"
}

variable "key_name" {
#   description = "Name of your EC2 key pair"
  type        = string
}
