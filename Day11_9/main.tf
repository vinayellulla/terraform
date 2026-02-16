provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0dc5681784bd0eed6"
  instance_type = var.allowed_vm_types[0]
  region        = tolist(var.allowed_region)[0]
  subnet_id     = "subnet-009a55b871460200a"

  lifecycle {
    create_before_destroy = false #Best practice is to set always to true
  }
}




