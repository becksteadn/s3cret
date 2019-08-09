import boto3
import botocore
import binascii
import base64
import os

from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend

def gen_key(password):
    digest = hashes.Hash(hashes.SHA256(), backend=default_backend())
    digest.update(password)
    return base64.urlsafe_b64encode(digest.finalize())

def handler(event, context):
    s3 = boto3.resource('s3')

    bucket_name = os.environ['BUCKET_NAME']

    key = gen_key(event['password'])
    cipher_suite = Fernet(key)

    cipher_filename = cipher_suite.encrypt(event['filename'])
    cipher_body = cipher_suite.encrypt('hello world')

    s3.put_object(Bucket=bucket_name, Key=cipher_filename, Body=cipher_body)

    plain_text = cipher_suite.decrypt(cipher_body)

    return {'success': 'true'}
