output "instance_id" {
    value = aws_autoscaling_group.ec2_asg.id
}

output "eip" {
    value = aws_eip.eip.id
}