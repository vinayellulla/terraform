terraform {
  backend "s3" {
    bucket       = "tf-files-ellulla"
    key          = "terraform/files"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_s3_bucket" "first_bucket" {
  bucket = "files-with-vinay"
}

resource "aws_instance" "vinay" {
  ami           = var.ami_id
  region        = var.config.region
  instance_type = var.allowed_types[1]


  tags = var.tags
}

variable "environment" {
  default = "Tooth-inthe-Market"
}

resource "aws_security_group" "SG" {
  name        = "Hello-Moto"
  description = "AWS Security Groups"

  ingress {
    from_port   = var.ingress_values[0]
    to_port     = var.ingress_values[2]
    protocol    = var.ingress_values[1]
    cidr_blocks = ["10.0.0.0/16"]
  }
}

