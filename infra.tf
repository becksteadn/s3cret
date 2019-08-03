provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_role" "s3cret_function" {

}

resource "aws_iam_policy" "s3cret_function" {

}

resource "aws_iam_policy_attachment" "s3cret_attachment" {

}

resource "aws_s3_bucket" "s3cret_bucket" {

}

resource "aws_lambda_function" "s3cret_function" {

}

resource "aws_api_gateway_rest_api" "s3cret_api" {
    
}