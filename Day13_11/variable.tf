variable "project_name" {
  default = "vinay kumar ellulla"

}

variable "environment" {
  type = object({
    name  = string,
    class = string
  })

  default = {
    name  = "ellulla"
    class = "PQ"
  }
}

variable "non_environment" {
  type = object({
    village = string
  })

  default = {
    village = "Armoor"
  }
}

variable "allowed_ports" {
  default = "80,443,8080,3306"
}

variable "instance_sizes" {
  type = map(string)
  default = {
    "dev"   = "t2.micro"
    "stage" = "t3.micro"
    "prod"  = "t3.large"
  }
}


variable "environments" {
  default = "stage"
}
