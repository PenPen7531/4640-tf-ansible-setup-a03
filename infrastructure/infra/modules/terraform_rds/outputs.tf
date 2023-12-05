output "host_address"{
    value = aws_db_instance.database.address
}

output "host_endpoint"{
    value = aws_db_instance.database.endpoint
}