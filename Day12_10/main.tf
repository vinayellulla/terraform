
provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_instance" "example_instance" {
  ami = "ami-0ba8d27d35e9915fb"
  #instance_type = "t2.micro"
  instance_type = var.environment == "Dev" ? "t3.micro" : "t2.micro"
  count         = var.instance_count
  tags          = var.tags
}


# resource "aws_security_group" "SG" {
#   name = "SG"

#   ingress {
#     from_port   = var.ingress_rules.from_port
#     to_port     = var.ingress_rules.to_port
#     protocol    = var.ingress_rules.protocol
#     cidr_blocks = var.ingress_rules.cidr_blocks
#   }
# }

resource "aws_security_group" "SG-2" {
  name = "SG-2"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

locals {
  instance_ids = aws_instance.example_instance[*].id
}

output "ID" {
  value = local.instance_ids

}

