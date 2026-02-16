
variable "region" {
  default = "ap-southeast-2"
}

variable "ami_id" {
  default = "ami-048ab8ac7e8c6533d"
}

variable "allowed_types" {
  default = ["t2.micro", "t2.nano", "t2.large"]

}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Name        = "EC2-Instance"
    Created_by  = "terraform"
  }
}


variable "ingress_values" {
  type    = tuple([number, string, number])
  default = [443, "tcp", 443]
}

variable "config" {
  type = object({
    instance_count = number
    region         = string
    monitoring     = bool
  })
  default = {
    instance_count = 1,
    monitoring     = true
    region         = "us-east-1"
  }
}


# Map type - IMPORTANT: Key-value pairs, keys must be unique
variable "instance_tags" {
  type        = map(string)
  description = "tags to apply to the ec2 instances"
  default = {
    "Environment" = "dev"
    "Project"     = "terraform-course"
    "Owner"       = "devops-team"
  }
  # Access: var.instance_tags["Environment"] = "dev"
  # Keys are always strings, values must match the declared type
}
