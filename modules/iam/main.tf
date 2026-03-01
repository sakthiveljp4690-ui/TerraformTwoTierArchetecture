data "aws_caller_identity" "current" {}

resource "aws_iam_role" "ec2_role" {
    name = "ec2_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_policy" "rds_policy" {
    name = "rds_iam_connect_policy"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "rds-db:connect"
            Effect = "Allow"
            Resource = "arn:aws:rds-db:ap-northeast-1:${data.aws_caller_identity.current.account_id}:dbuser:${var.rds_db_resource_id}/iam_db_user"
        }]
    })    
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
    role = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "rds_policy_attachment" {
    role = aws_iam_role.ec2_role.name
    policy_arn = aws_iam_policy.rds_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
    name = "ec2_instance_profile"
    role = aws_iam_role.ec2_role.name 
}


