provider "aws" {
  region = "ap-southeast-2"
}

provider "vault" {
  address          = "http://3.27.85.53:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = "58bb031f-096f-4f69-2bae-ed62bf1823bb"
      secret_id = "13963fa4-e745-5206-ad2b-baf5f7c17487"
    }
  }
}

data "vault_kv_secret_v2" "terraform" {
  mount = "bhavithanugu" // change it according to your mount
  name  = "ellulla2"     // change it according to your secret
}

# resource "aws_instance" "example" {
#   ami           = "ami-0ba8d27d35e9915fb"
#   instance_type = "t2.micro"
#   subnet_id     = "subnet-0143eec0ece1c2ac0"

#   tags = {
#     secret = data.vault_kv_secret_v2.terraform.data["username"]
#   }
# }

resource "aws_s3_bucket" "ellulla" {
  bucket = data.vault_kv_secret_v2.terraform.data["ellulla2"]
}

