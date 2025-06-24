import boto3
import os
import json
import datetime

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    now = datetime.datetime.utcnow().isoformat()
    payload = {"timestamp": now, "message": "Hello Binance!"}

    bucket_name = os.environ["BUCKET_NAME"]
    key = f"test/{now}.json"

    s3.put_object(Bucket=bucket_name, Key=key, Body=json.dumps(payload))
    return {"status": "ok"}
