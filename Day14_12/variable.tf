variable "instance_type" {
  default = "t2.micro"

  validation {
    condition     = length(var.instance_type) >= 2 && length(var.instance_type) <= 20
    error_message = "Instance type must be in between 2 and 20 Charcters"
  }

  validation {
    condition     = can(regex("^t[2-3]\\.", var.instance_type))
    error_message = "Please enter valid instance, like t2 and t3"
  }
}


variable "backup_name" {
  default = "daily_backup"

  validation {
    condition     = endswith(var.backup_name, "_backup")
    error_message = "Backup name must end with '_backup'"
  }
}

variable "credentials" {
  default = "xyz123"
  # sensitive = true
}

variable "user_locations" {
  default = ["us-east-2", "ap-sotheast-2", "us-east-2"]
}

variable "default_locations" {
  default = ["ap-southeast-1", "us-east-2", "us-west-2"]
}

variable "monthly_costs" {
  type    = list(number)
  default = [-50, 100, 75, 200] # -50 is a credit
}


