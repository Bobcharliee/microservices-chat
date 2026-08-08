data aws_ami "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_iam_role" "ec2_db_role" {
  name = "ec2-db-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = {
    tag-key = "ms-db-role"
  }
}

resource "aws_iam_role_policy" "secrets_access" {
  name = "secrets-access-policy"
  role = aws_iam_role.ec2_db_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.secrets_arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecr_access" {
  name = "ecr-access-policy"
  role = aws_iam_role.ec2_db_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:StartInstanceRefresh",
        ]
        Resource = "var.ecr_arn"
      },

      {
        Effect  = "Allow"
        Action  = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.deployment_bucket_name}/*" 
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_db_profile" {
  name = "ec2-db-profile"
  role = aws_iam_role.ec2_db_role.name
}

resource "aws_launch_template" "ms-launch-template" {
  name_prefix            = "${var.project_name}-lt"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids

  user_data = base64encode(file("${path.module}/user-data.sh"))

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_db_profile.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      delete_on_termination = true
    }
  }
}

resource "aws_autoscaling_group" "ms-autoscaling-group" {
  name                      = "${var.project_name}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.ms-launch-template.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg"
    propagate_at_launch = true
  }
}


