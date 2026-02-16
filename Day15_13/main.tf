provider "aws" {
  region = "ap-southeast-2"
}

data "aws_vpc" "vpc_name" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
}

data "aws_subnet" "shared" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
  vpc_id = data.aws_vpc.vpc_name.id
}

data "aws_ami" "linux2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.linux2.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.shared.id

  tags = {
    Name = "Data-resource-example"
  }
}

