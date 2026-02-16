provider "aws" {
  region = "ap-southeast-2"
}


resource "aws_vpc" "primary_vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "Primary_VPC"
  }
}


resource "aws_vpc" "secondary_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Secondary VPC"
  }
}


resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = "10.1.0.0/20"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet A"
  }

}


resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.secondary_vpc.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet B"
  }
}


resource "aws_internet_gateway" "primary_igw" {
  vpc_id = aws_vpc.primary_vpc.id

  tags = {
    Name = "Primary Gateway"
  }
}


resource "aws_internet_gateway" "secondary_igw" {
  vpc_id = aws_vpc.secondary_vpc.id

  tags = {
    Name = "Secondary Gateway"
  }
}


resource "aws_route_table" "RT_1" {
  vpc_id = aws_vpc.primary_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_igw.id
  }

  tags = {
    Name = "RT-1"
  }
}


resource "aws_route_table" "RT_2" {
  vpc_id = aws_vpc.secondary_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary_igw.id
  }

  tags = {
    Name = "RT-2"
  }
}

resource "aws_route_table_association" "RTS-1" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.RT_1.id
}

resource "aws_route_table_association" "RTS-2" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.RT_2.id
}

resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_owner_id = var.vpc_peering_owner_id
  peer_vpc_id   = aws_vpc.secondary_vpc.id
  vpc_id        = aws_vpc.primary_vpc.id
  auto_accept   = true

}


# Add to RT_1 (primary VPC route table)
resource "aws_route" "primary_to_secondary" {
  route_table_id            = aws_route_table.RT_1.id
  destination_cidr_block    = aws_vpc.secondary_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# Add to RT_2 (secondary VPC route table)
resource "aws_route" "secondary_to_primary" {
  route_table_id            = aws_route_table.RT_2.id
  destination_cidr_block    = aws_vpc.primary_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_instance" "primary_instance" {
  ami                    = "ami-0ba8d27d35e9915fb"
  subnet_id              = aws_subnet.subnet_a.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.primary-sg.id]
  key_name               = "ForDocker"

  tags = {
    Name = "Primary Instance"
  }
}

resource "aws_instance" "secondary_instance" {
  ami                    = "ami-0ba8d27d35e9915fb"
  subnet_id              = aws_subnet.subnet_b.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.secondary-sg.id]
  key_name               = "ForDocker"

  tags = {
    Name = "Secondary Instance"
  }
}


resource "aws_security_group" "primary-sg" {
  name        = "web-SG-1"
  description = "Security group for Primary VPC"
  vpc_id      = aws_vpc.primary_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }


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

resource "aws_security_group" "secondary-sg" {
  name        = "web-SG-2"
  description = "Security group for Secondary VPC"
  vpc_id      = aws_vpc.secondary_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }


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


