# terraform {
#   backend "s3" {
#     bucket         = "vinay-safety-satefile"
#     key            = "remotebackend/terraform.tfstate"
#     region         = "ap-southeast-2"
#     dynamodb_table = "terraform-lock"
#   }
# }
