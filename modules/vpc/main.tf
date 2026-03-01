resource "aws_vpc" "free_tier_vpc" {
    enable_dns_hostnames = true
    cidr_block = var.vpc_range
    tags = {
        Name = "terraform-free-tier-vpc"
    }
}

resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.free_tier_vpc.id
  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table" "private_routetable" {
  vpc_id = aws_vpc.free_tier_vpc.id
  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route" "public_route" {
    route_table_id = aws_route_table.public_routetable.id
    gateway_id = aws_internet_gateway.igw.id
    destination_cidr_block = var.internet_cidr
}

resource "aws_route" "private_route" {
    route_table_id = aws_route_table.private_routetable.id
    gateway_id = aws_nat_gateway.natgw.id
    destination_cidr_block = var.internet_cidr
}


resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.free_tier_vpc.id
    cidr_block = var.public_network_range
    availability_zone = "ap-northeast-1a"
    tags = {
      Name = "public"
    }
}

resource "aws_subnet" "public_subnet_az2" {
    vpc_id = aws_vpc.free_tier_vpc.id
    cidr_block = var.public_network_range_2
    availability_zone = "ap-northeast-1c"
    tags = {
      Name = "public"
    }
}

resource "aws_subnet" "private_subnet_az1" {
    vpc_id = aws_vpc.free_tier_vpc.id
    cidr_block = var.private_network_range
    availability_zone = "ap-northeast-1a"
    tags = {
      Name = "private"
    }
}

resource "aws_subnet" "private_subnet_az2" {
    vpc_id = aws_vpc.free_tier_vpc.id
    cidr_block = var.private_network_range_2
    availability_zone = "ap-northeast-1c"
    tags = {
      Name = "private"
    }
}

resource "aws_route_table_association" "public_association_2" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_routetable.id
}

resource "aws_route_table_association" "public_association" {
    subnet_id = aws_subnet.public_subnet_az2.id
    route_table_id = aws_route_table.public_routetable.id
}

resource "aws_route_table_association" "private_association" {
    subnet_id = aws_subnet.private_subnet_az1.id
    route_table_id = aws_route_table.private_routetable.id
}

resource "aws_route_table_association" "private_association_2" {
    subnet_id = aws_subnet.private_subnet_az2.id
    route_table_id = aws_route_table.private_routetable.id
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.free_tier_vpc.id
    tags = {
      Name = "main"
    }
}

resource "aws_vpc_endpoint" "ssm_interface_endpoint" {
  vpc_id = aws_vpc.free_tier_vpc.id
  service_name = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids = [ aws_subnet.private_subnet_az1.id, aws_subnet.private_subnet_az2.id ]
  security_group_ids = [ var.vpc_endpoint_sg ]
  private_dns_enabled = true 
  tags = {
    name = "ssm_interface_endpoint"
  }
}

resource "aws_vpc_endpoint" "ec2_message_interface_endpoint" {
  vpc_id = aws_vpc.free_tier_vpc.id
  service_name = "com.amazonaws.ap-northeast-1.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [ aws_subnet.private_subnet_az1.id, aws_subnet.private_subnet_az2.id ]
  security_group_ids = [ var.vpc_endpoint_sg ]
  private_dns_enabled = true 
  tags = {
    name = "ec2_message_interface_endpoint"
  }
}

resource "aws_vpc_endpoint" "ssm_message_interface_endpoint" {
  vpc_id = aws_vpc.free_tier_vpc.id
  service_name = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [ aws_subnet.private_subnet_az1.id, aws_subnet.private_subnet_az2.id ]
  security_group_ids = [ var.vpc_endpoint_sg ]
  private_dns_enabled = true 
  tags = {
    name = "ssm_message_interface_endpoint"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = var.eip
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    name = "terraform-nat-gw"
  }
}