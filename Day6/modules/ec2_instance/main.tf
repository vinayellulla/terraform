provider "aws" {
  region = "ap-southeast-2"
}


variable "ami" {
  description = "This is the ami for the EC2 instance"
}

variable "instance_type" {
  description = "This is the EC2 instance type"
}

variable "subnet_id" {
  description = "To create a EC2 instance in it"
}

resource "aws_instance" "exampele" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

}

