provider "aws" {
  region = "ap-southeast-2"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "example" {
  key_name   = "demo-vinay"
  public_key = file("${path.module}/Day5.pub")
}

resource "aws_vpc" "vinay_vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "vinay_subnet" {
  vpc_id                  = aws_vpc.vinay_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true
}


resource "aws_internet_gateway" "vinay-igw" {
  vpc_id = aws_vpc.vinay_vpc.id
}

resource "aws_route_table" "vinay-route-tb" {
  vpc_id = aws_vpc.vinay_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vinay-igw.id
  }

}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.vinay_subnet.id
  route_table_id = aws_route_table.vinay-route-tb.id
}

resource "aws_security_group" "websg" {
  name   = "web"
  vpc_id = aws_vpc.vinay_vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
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

  tags = {
    Name = "WEB-SG"
  }
}

resource "aws_instance" "Server" {
  ami                    = "ami-0ba8d27d35e9915fb"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id              = aws_subnet.vinay_subnet.id


  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/Day5")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance' ",
      "sudo apt update -y",
      "sudo apt-get install -y python3-pip",
      "cd home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py &"
    ]
  }
}


