output "private_ec2_sg" {
    value = aws_security_group.private_ec2_sg.id
}

output "rds_sg_id" {
    value = aws_security_group.rds_sg.id
}

output "vpc_endpoint_sg" {
    value = aws_security_group.vpc_endpoint_sg.id
}

output "alb_sg" {
    value = aws_security_group.alb_sg.id
}