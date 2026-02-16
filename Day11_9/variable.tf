variable "allowed_region" {
  type    = set(string)
  default = ["ap-southeast-2", "us-east-2", "eu-west-1"]
}

variable "allowed_vm_types" {
  type    = list(string)
  default = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
}


