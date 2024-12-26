import boto3
from botocore.exceptions import NoCredentialsError

def upload_to_s3(file_name, bucket_name, object_name=None):
    """
    Upload a file to an S3 bucket.

    :param file_name: 'cleaned_bank_transactions.csv'
    :param bucket_name: 'fraud-detection2'
    :param object_name: 'cleaned_bank_transactions.csv'
    """
    s3 = boto3.client('s3')
    try:
        s3.upload_file(file_name, bucket_name, object_name or file_name)
        print(f"File {file_name} successfully uploaded to bucket {bucket_name}")
    except FileNotFoundError:
        print("The file was not found.")
    except NoCredentialsError:
        print("AWS credentials not available.")

# File to upload
file_name = 'cleaned_bank_transactions.csv'

# Replace with your S3 bucket name
bucket_name = 'fraud-detection2'
object_name = 'cleaned_bank_transactions.csv'

# Upload the file
upload_to_s3(cleaned_bank_transactions.csv, fraud-detection2, cleaned_bank_transactions.csv)
