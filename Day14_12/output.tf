output "credentials" {
  value = var.credentials
}

output "locations" {
  value = local.all_locations

}

output "unique_locations" {
  value = local.unique_locations

}

output "positive_costs" {
  value = local.positive_costs
}

output "max" {
  value = local.max_cost
}

output "min" {
  value = local.min_cost
}

output "avg" {
  value = local.avg_cost
}

output "total_cost" {
  value = local.total_cost

}


output "time" {
  value = local.curr_time
}

output "format1" {
  value = local.format1
}

output "format2" {
  value = local.format2
}

output "file_data" {
  value = local.file_data

}
