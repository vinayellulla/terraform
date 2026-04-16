terraform {
  backend "s3" {
    bucket         = "qrcodestore-123"
    key            = "remotebackend/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-lock"
  }
}
