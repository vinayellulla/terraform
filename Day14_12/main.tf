terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.32.0"
    }
  }
}

provider "aws" {
  region = "ap-sotheast-2"
}

locals {
  all_locations    = concat(var.user_locations, var.default_locations)
  unique_locations = toset(local.all_locations)
  positive_costs   = [for cost in var.monthly_costs : abs(cost)]

  //list_cost  = split(",", local.positive_costs)
  max_cost   = max(local.positive_costs...)
  min_cost   = min(local.positive_costs...) # Those ... dots are spread operators, used to treat each number seperatly as numericals 
  total_cost = sum(local.positive_costs)
  avg_cost   = local.total_cost / length(local.positive_costs)

  curr_time = timestamp()

  format1 = formatdate("yyyyMMdd", local.curr_time)
  format2 = formatdate("YYYY-MM-DD", local.curr_time)

  time_stamp = "backup-${local.format2}"

  file_exists = fileexists("./config.json")

  file_data = local.file_exists ? jsondecode(file("./config.json")) : {}
}










