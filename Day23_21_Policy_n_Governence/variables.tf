variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "terraform-governance-demo"
}
