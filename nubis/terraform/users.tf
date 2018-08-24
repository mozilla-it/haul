resource "aws_iam_user" "snippets_bucket" {
  name = "${var.service_name}-${var.environment}-snippets_bucket"
  path = "/applicaton/${var.service_name}/"
}

resource "aws_iam_access_key" "snippets_bucket" {
  user = "${aws_iam_user.snippets_bucket.name}"
}

resource "aws_iam_user_policy" "snippets_bucket" {
  name = "snippets-bucket-access"
  user = "${aws_iam_user.snippets_bucket.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
          "${module.snippets.arn}",
      "${module.snippets.arn}/*"
      ]
    }
  ]
}
EOF
}
