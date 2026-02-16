
provider "aws" {
  region = "ap-southeast-2"

}

resource "aws_instance" "example_day4" {
  ami           = "ami-0ba8d27d35e9915fb"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0143eec0ece1c2ac0"
  tags = {
    Name = "testing-remotebackend"
  }
}

resource "aws_s3_bucket" "example_s3_bucket" {
  bucket = "vinay-safety-satefile"

}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
