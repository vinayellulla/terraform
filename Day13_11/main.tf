terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.32.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

locals {
  formatted_name = lower(replace(var.project_name, " ", "CEO"))
  new_tags       = merge(var.environment, var.non_environment)
}


locals {
  port_list = split(",", var.allowed_ports)

  sg_rules = [for port in local.port_list : {
    name : "port-${port}"
    port : port
    description : "Allow traffic on port ${port}"
  }]

  instance_size = lookup(var.instance_sizes, var.environments, "t2.micro")
}

resource "aws_s3_bucket" "vinay_bucket" {
  bucket = local.formatted_name
  tags   = local.new_tags
}


