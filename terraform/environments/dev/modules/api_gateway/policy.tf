resource "aws_iam_policy" "s3_access" {
  name        = "s3_access_policy"
  path        = "/"
  description = ""

  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": "s3:PutObject",
          "Resource": "${var.s3_bucket_arn}/*"
         }
       ]
     }
    )
  }

resource "aws_iam_policy_attachment" "s3_access_attach" {
  name = "s3_access_attach"
  roles = [
    aws_iam_role.api.name
  ]
  policy_arn = aws_iam_policy.s3_access.arn
}

resource "aws_iam_policy_attachment" "log_attach" {
  name = "log_attach"
  roles = [
    aws_iam_role.api.name
  ]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}
