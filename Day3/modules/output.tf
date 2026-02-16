output "public_ip_add" {
  value = aws_instance.example.private_ip  #resource-type.resource-name.output metric you want 
}