import boto3
import json
from datetime import datetime, timedelta

# --- CONFIG --- #
region = "eu-west-3"
queue_name = "binance-trades-sqs-dev"
account_id = boto3.client("sts").get_caller_identity()["Account"]
queue_url = f"https://sqs.{region}.amazonaws.com/{account_id}/{queue_name}"

# Exemple : 1 date ou plusieurs
dates_to_send = [
    "2024-05-01",
    "2024-05-02"
]

# --- BOTO3 client --- #
sqs = boto3.client("sqs", region_name=region)


def app():
    # --- Send each message --- #
    for date in dates_to_send:
        for h in range(0, 24):
            payload = json.dumps({"date": date, "hour": str(h).zfill(2)})

            response = sqs.send_message(
                QueueUrl=queue_url,
                MessageBody=payload
            )

            print(f"✅ Sent {date} → MessageId: {response['MessageId']}")


def main():
    app()


if __name__ == '__main__':
    main()
