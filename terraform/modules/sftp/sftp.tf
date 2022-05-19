# Transfer Server w/ EIP
resource "aws_transfer_server" "sftp" {
  endpoint_type = "VPC"
  security_policy_name = var.security_policy_name
  identity_provider_type = "AWS_LAMBDA"
  invocation_role = "${aws_iam_role.transfer_server_role.arn}"
  function = "${aws_lambda_function.lambda.invoke_arn}"

  endpoint_details {
    address_allocation_ids = [aws_eip.sftp.id]
    security_group_ids = [aws_security_group.sg.id]
    # subnet_ids = [aws_subnet.public.id]
    # vpc_id = aws_vpc.vpc.id
  }
}

resource "aws_eip" "sftp" {

}

# SG controlling SFTP access w/ custom Ingress Rule(s)
resource "aws_security_group" "sg" {
  name        = "${var.name}-allow-sftp"
  description = "Security group controlling access to ${var.name} SFTP server."
  # vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-allow-sftp"
  }
}

resource "aws_security_group_rule" "ingress" {
  for_each = var.users
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = each.value["AllowFrom"] != null ? each.value["AllowFrom"] : [ "127.0.0.1/32" ]
  description       = each.key
  security_group_id = aws_security_group.sg.id
}

# IAM role
data "aws_iam_policy_document" "transfer_server_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "transfer_server_assume_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.s3.arn,
      "${aws_s3_bucket.s3.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "transfer_server_to_cloudwatch_assume_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "transfer_server_role" {
  name               = "${var.name}-transfer_server_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "transfer.amazonaws.com"
        }
      },
    ]
  })
}

