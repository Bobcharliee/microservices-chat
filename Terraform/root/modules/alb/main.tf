# Create S3 bucket for load balancer access logs
resource "aws_s3_bucket" "load_balancer_logs" {
  bucket = "votingapp-load-balancer-logs-tf-thecloudchief"
}

resource "aws_s3_bucket_policy" "allow_elb_logging" {
  bucket = aws_s3_bucket.load_balancer_logs.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSLogDeliveryWrite"
        Effect    = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action = [
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.load_balancer_logs.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid       = "AWSLogDeliveryAclCheck"
        Effect    = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action = [
          "s3:GetBucketAcl"
        ]
        Resource = aws_s3_bucket.load_balancer_logs.arn
      }
    ]
  })
}

resource "aws_lb" "ms-load-balancer" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.load_balancer_security_group_id]
  subnets            = var.subnet_ids

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.load_balancer_logs.id
    prefix  = "${var.project_name}-alb-logs"
    enabled = true
  }


}

resource "aws_lb_target_group" "ms-target-group" {
  name     = "${var.project_name}-tg"
  port     = var.http_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

resource "aws_lb_listener" "ms-listener" {
  load_balancer_arn = aws_lb.ms-load-balancer.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ms-target-group.arn
  }
}