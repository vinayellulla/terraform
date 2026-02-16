provider "aws" {
  region = "ap-southeast-2"
}

module "ec2-instance" {
  source = "./modules"
  ami_value = "ami-0ba8d27d35e9915fb"
  instance_type_value = "t2.micro"
  subnet_id_value = "subnet-0143eec0ece1c2ac0"
}

