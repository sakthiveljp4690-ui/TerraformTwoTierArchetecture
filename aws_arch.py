from diagrams import Diagram, Cluster
from diagrams.aws.network import VPC, InternetGateway, NATGateway, PublicSubnet, PrivateSubnet, ALB
from diagrams.aws.compute import EC2AutoScaling
from diagrams.aws.database import RDS
from diagrams.aws.management import SystemsManager
from diagrams.aws.security import IAM
from diagrams.aws.network import PrivateSubnet
from diagrams.onprem.network import Internet

with Diagram("secure Two-Tier Architecture", show=True):

    internet = Internet("Internet")

    with Cluster("VPC (10.1.0.0/16)"):

        igw = InternetGateway("Internet Gateway")

        with Cluster("Public Subnets (AZ-1a, AZ-1c)"):
            alb = ALB("Application Load Balancer")
            nat = NATGateway("NAT Gateway")

        with Cluster("Private Subnets (AZ-1a, AZ-1c)"):

            asg = EC2AutoScaling("Auto Scaling Group\n(2 EC2 Instances)")
            rds = RDS("RDS MySQL\nMulti-AZ\nIAM DB Auth Enabled")

            with Cluster("VPC Interface Endpoints"):
                ssm = PrivateSubnet("SSM")
                ec2msg =  PrivateSubnet("EC2 Messages")
                ssmm = PrivateSubnet("SSM Messages")

            iam = IAM("IAM Role\n(ssm ,rds-db-connect)")

    # Connections
    internet >> igw >> alb
    alb >> asg
    asg >> rds
    asg >> nat >> igw

    asg >> iam
    asg >> ssm
    asg >> ec2msg
    asg >> ssmm