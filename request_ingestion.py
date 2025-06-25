import boto3
import json

# --- CONFIG --- #
region = "eu-west-3"
queue_name = "ingestion-sqs-dev"
account_id = boto3.client("sts").get_caller_identity()["Account"]
queue_url = f"https://sqs.{region}.amazonaws.com/{account_id}/{queue_name}"

dates_to_send = [
    "2025-05-03"
]

# --- BOTO3 client --- #
sqs = boto3.client("sqs", region_name=region)


def send_all_requests():
    # --- Send each message --- #
    for date in dates_to_send:
        for hour in range(0, 24):
            hour_str = str(hour).zfill(2)
            send_request(date, hour_str, "aggTrades", "BTCUSDT")


def send_request(
        date: str,
        hour: str,
        endpoint: str ="aggTrades", # "aggTrades" | "klines",
        symbol: str="BTCUSDT",
        interval: str|None = None #"1m" for klines
):
    payload = json.dumps({
        "date": date,
        "hour": hour,
        "endpoint": endpoint,
        "symbol": symbol,
        "interval": interval,
    })

    response = sqs.send_message(
        QueueUrl=queue_url,
        MessageBody=payload
    )

    print(f"✅ Sent ingestion request for table: {endpoint}, for symbol: {symbol}, for period: {date}, {hour}:00")
    print(f"→ MessageId: {response['MessageId']} to SQS queue")

def main():
    send_all_requests()


if __name__ == '__main__':
    main()
