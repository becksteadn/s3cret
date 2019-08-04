import boto3
import botocore

def handler(event, context):
    s3 = boto3.resource('s3')
    return {'success': 'true'}
