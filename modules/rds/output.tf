output "rds_db_endpoint" {
    value = aws_db_instance.rds_db.endpoint
}

output "rds_db_resource_id" {
    value = aws_db_instance.rds_db.resource_id
}