provider "aws" {
  region = "ap-southeast-2"
}

locals {
  users = csvdecode(file("user.csv"))
}

resource "aws_iam_user" "users" {

  for_each = { for user in local.users : user.first_name => user }

  name = lower("${substr(each.value.first_name, 0, 1)}${(each.value.last_name)}")
  path = "/users/"

  tags = {
    "Displayname" = "${each.value.first_name}${each.value.last_name}"
    "Department"  = each.value.department
    "Jobtitle"    = each.value.job_title
  }
}

# output "user" {
#   value = aws_iam_user.users.name

# }

resource "aws_iam_user_login_profile" "users" {

  for_each                = aws_iam_user.users
  user                    = each.value.name
  password_reset_required = true

  lifecycle {
    ignore_changes = [password_reset_required, password_length]
  }
}

