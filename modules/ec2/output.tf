output "instance_id" {
    value = aws_instance.private_instance.id
}

output "eip" {
    value = aws_eip.eip.id
}