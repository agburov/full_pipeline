resource "aws_iam_role" "service" {
  name = "EC2CloudWatchLogging"

  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Principal": {
                  "Service": "ec2.amazonaws.com"
              },
              "Action": "sts:AssumeRole"
          }
      ]
}
EOF

  tags = {
    Name = "Intended role"
  }
}

resource "aws_iam_instance_profile" "docker_cloudwatch_logger" {
  name = "EC2CloudWatchRole"
  role = aws_iam_role.service.name
}

resource "aws_iam_role_policy" "this" {
  name = "CloudWatchAgentServerPolicy"
  role = aws_iam_role.service.id

  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "cloudwatch:PutMetricData",
                  "ec2:DescribeVolumes",
                  "ec2:DescribeTags",
                  "logs:PutLogEvents",
                  "logs:DescribeLogStreams",
                  "logs:DescribeLogGroups",
                  "logs:CreateLogStream",
                  "logs:CreateLogGroup"
              ],
              "Resource": "*"
          },
          {
              "Effect": "Allow",
              "Action": [
                  "ssm:GetParameter"
              ],
              "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
          }
      ]
}
EOF
}
