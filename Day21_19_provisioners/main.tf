terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "terraform--provision-demo"
  description = "Allow SSH inbounds"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "demo" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  subnet_id                   = "subnet-00337c8fc222956fb"
  associate_public_ip_address = true


  tags = {
    Name = "terraform-provisioner-demo"
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

  # provisioner "local-exec" {
  #   command = "echo 'Local-exec: created instance ${self.id} with IP ${self.public_ip}"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt-get udate",
  #     "echo 'Hello from remote-exec' | sudo tee /tmp/remote_exec.txt"
  #   ]
  # }

  provisioner "file" {
    source      = "${path.module}/scripts/welcome.sh"
    destination = "/tmp/welcome.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/welcome.sh",
      "sudo /tmp/welcome.sh"
    ]
  }
}

