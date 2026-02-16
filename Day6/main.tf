provider "aws" {
  region = "ap-southeast-2"
}

variable "ami" {
  description = "value"
}

variable "instance_type" {
  description = "value"
  type        = map(string)

  default = {
    "dev"           = "t2.micro"
    "stage"         = "t2.medium"
    "instance_type" = "t2.xlarge"
  }
}

variable "subnet_id" {
  description = "subnet of the EC2"

}

module "ec2_instance" {
  source        = "./modules/ec2_instance"
  ami           = var.ami
  subnet_id     = var.subnet_id
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
}

