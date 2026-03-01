module "iam" {
    source = "./modules/iam"
    rds_db_resource_id = module.rds.rds_db_resource_id
}

module "security_groups" {
    source = "./modules/sg"
    internet_cidr = var.internet_cidr
    private_network_range = var.private_network_range
    vpc_id = module.vpc.vpc_id
    vpc_range = var.vpc_range
}

module "ec2" {
    source = "./modules/ec2"
    private_ec2_sg = module.security_groups.private_ec2_sg
    private_subnet_az1 = module.vpc.private_subnet_az1
    instance_type = var.instance_type
    ec2_instance_profile = module.iam.ec2_instance_profile
    rds_db_endpoint = module.rds.rds_db_endpoint
}

module "vpc" {
    source = "./modules/vpc"
    vpc_range = var.vpc_range
    public_network_range = var.public_network_range
    public_network_range_2 = var.public_network_range_2
    private_network_range = var.private_network_range
    private_network_range_2 = var.private_network_range_2
    internet_cidr = var.internet_cidr
    vpc_endpoint_sg = module.security_groups.vpc_endpoint_sg
    eip = module.ec2.eip
}

module "rds" {
    source = "./modules/rds"
    private_subnet_az1 = module.vpc.private_subnet_az1
    private_subnet_az2 = module.vpc.private_subnet_az2
    db_username = var.db_username
    db_password = var.db_password
    rds_sg_id = module.security_groups.rds_sg_id
    vpc_id = module.vpc.vpc_id
}

module "alb" {
    source = "./modules/alb"
    alb_sg = module.security_groups.alb_sg
    public_subnet = module.vpc.public_subnet
    instance_id = module.ec2.instance_id
    vpc_id = module.vpc.vpc_id
    public_subnet_az2 = module.vpc.private_subnet_az2
}