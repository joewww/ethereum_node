
variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

# ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180109 (ami-41e0b93b)
variable "aws_amis" {
  default = {
    #"us-east-1" = "ami-41e0b93b"
    # snapshot of ami-41e0b93b, installed go-ethereum, startup script
    "us-east-1" = "ami-cffb9eb0"
  }
}

variable "keyname" {
  default = "INSERT-KEYNAME-HERE"
}

variable "me" {
  default = "YOUR-IP-HERE/32"
}


####
variable "vpc_cidr" {
  description = "ethereum CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "ethereum CIDR for the public subnet"
  default = "10.0.1.0/24"
}

