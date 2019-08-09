provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_role" "s3cret_function" {
    name = "s3cret_function"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "S3Upload" {
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:TODO",
            "Resource": "${aws_s3_bucket.s3cret_bucket.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "S3Download" {
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": "${aws_s3_bucket.s3cret_bucket.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "S3Upload" {
    name = "s3cret_upload"
    roles = ["${aws_iam_role.s3cret_function.name}"]
    policy_arn = "${aws_iam_policy.S3Upload.arn}"
}

resource "aws_iam_policy_attachment" "S3Download" {
    name = "s3cret_download"
    roles = ["${aws_iam_role.s3cret_function.name}"]
    policy_arn = "${aws_iam_policy.S3Download.arn}"
}


resource "aws_s3_bucket" "s3cret_bucket" {
    bucket = "s3cret"
    acl = "private"
}

resource "aws_lambda_function" "s3cret" {
    function_name = "s3cret"
    filename = "function/build/build.zip"
    source_code_hash = "${filebase64sha256("function/build/build.zip")}"
    role = "${aws_iam_role.s3cret_function.arn}"
    handler = "main.handler"
    runtime = "python3.7"
    timeout = "5"
    environment {
        variables {
            BUCKET_NAME = "${aws_s3_bucket.s3cret_bucket.bucket}"
        }
    }
}
