output "public_subnet" {
    value = aws_subnet.public_subnet.id
}

output "public_subnet_az2" {
    value = aws_subnet.public_subnet_az2.id
}

output "private_subnet_az1" {
    value = aws_subnet.private_subnet_az1.id
}

output "private_subnet_az2" {
    value = aws_subnet.private_subnet_az2.id
}

output "vpc_id" {
    value = aws_vpc.free_tier_vpc.id
}